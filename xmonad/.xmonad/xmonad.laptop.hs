---------------------------------------------------------
--            XMonad Config by Anapal                  --
--     My personal config for my (or your) needs.      --
--                                                     --
--      > https://github.com/AnapalOne/dotfiles        --
---------------------------------------------------------

import XMonad

import Data.Monoid
import Data.Char (isSpace)
import System.Exit
import System.IO
import XMonad.ManageHook
import Graphics.X11.ExtraTypes.XF86

import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.ConfirmPrompt

import XMonad.Config.Desktop

import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS (prevWS, nextWS)
import XMonad.Actions.FloatKeys
import XMonad.Actions.FloatSnap

import XMonad.Layout.NoBorders
import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing
import XMonad.Layout.Circle
import XMonad.Layout.Renamed
import XMonad.Layout.Hidden

import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicProperty (dynamicPropertyChange)
import XMonad.Hooks.SetWMName

import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad
import XMonad.Util.Cursor

import qualified XMonad.StackSet as W
import qualified Data.Map        as M



---------------------------------------------------------
-- Configs
-- > For quick configuration without scrolling the entire config file. 
--   (it's a little tiring for me to find some parts that I want to configure) 
---------------------------------------------------------

myTerminal              = "alacritty"
myModMask               = mod4Mask -- win key
myCursor                = xC_left_ptr

myBorderWidth        = 3
myNormalBorderColor  = "#849DAB"
myFocusedBorderColor = "#24788F"

myWorkspaceList, myWorkspaceListWords :: [String]
myWorkspaceList = ["\xf120", "\xf121", "\xf0239", "\xf718", "\xf03d", "\xf11b", "\xf1d7", "\xf0388", "\xf1fc"] -- Icons.
myWorkspaceListWords = ["ter","dev","www","doc","vid","game","chat","mus","art"] -- Words.

    -- Size and position of window when it is toggled into floating mode.
toggleFloatSize = (W.RationalRect (0.01) (0.06) (0.50) (0.50))

    -- Applications in spawnSelected. (Home or modm + f)
myGridSpawn = [ ("\xf121 Sublime Text",   "subl"), 
                ("\xf269 Firefox",        "firefox"), 
                ("\xea84 Github Desktop", "github-desktop"),
                ("\xf718 LibreOffice",    "libreoffice"), 
                ("\xf07b Nemo",           "nemo"), 
                ("\xf008 Kdenlive" ,      "kdenlive"),
                ("\xfb6e Discord",        "discord"),
                ("\xf1bc Spotify",        "spotify-launcher"), 
                ("\xf7ea GIMP",           "gimp"), 
                ("\xf1fc Krita",          "krita"), 
                ("\xf03d OBS",            "obs"),
                ("\xf028 Audacity",       "audacity"), 
                ("\xf11b Steam",          "steam")
              ]



---------------------------------------------------------
-- Workspaces
-- > 9 workspaces for the terminal application, development tools/software, 
--   browsers, documents (libreoffice or msoffice), videos, gaming, 
--   messaging apps (discord, messenger, etc), music, and art.
---------------------------------------------------------

myWorkspaces = clickable . (map xmobarEscape) $ myWorkspaceList 
    where
          clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                        (i,ws) <- zip [1..9] l,
                        let n = i ]



---------------------------------------------------------
-- Key Binds
-- > These are keybindings that I use for everything in xmonad. Might add a help section for this.
-- 
-- > modm = myModMask
-- > Do xev | sed -ne '/^KeyPress/,/^$/p' for key maps.
---------------------------------------------------------

altMask :: KeyMask
altMask = mod1Mask

playerctlPlayers = "--player=spotify,cmus,spotifyd"

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
 
    -- // windows
    [ ((modm,               xK_BackSpace ), kill)                               -- close focused window
    , ((modm,                  xK_space  ), sendMessage NextLayout)             -- rotate layout
    , ((modm .|. shiftMask,    xK_space  ), setLayout $ XMonad.layoutHook conf) -- reset layout order
    , ((mod1Mask,              xK_Tab    ), windows W.focusUp     )             -- rotate focus between windows
    , ((modm,                  xK_Return ), windows W.swapMaster  )             -- swap focus master and window
    , ((modm .|. shiftMask,    xK_comma  ), sendMessage Shrink    )             -- decreases master window size
    , ((modm .|. shiftMask,    xK_period ), sendMessage Expand    )             -- increases master window size
    , ((modm,                  xK_comma  ), windows W.swapUp      )             -- move tiled window
    , ((modm,                  xK_period ), windows W.swapDown    )             --
    , ((modm,               xK_backslash ), withFocused hideWindow)             -- hide window
    , ((modm .|. shiftMask, xK_backslash ), popOldestHiddenWindow)              -- restore the last hidden window

    -- // workspaces
    , ((modm,           xK_Home ), prevWS)                   -- switch workspace to the left
    , ((modm,            xK_End ), nextWS)                   -- switch workspace to the right

    -- // floating windows
    , ((modm .|. shiftMask,   xK_Tab   ), withFocused toggleFloat)                      -- toggle between tiled and floating window
    , ((modm,                 xK_Up    ), withFocused (keysMoveWindow (0,-35)))         -- move floating window 
    , ((modm,                 xK_Down  ), withFocused (keysMoveWindow (0,35)))          -- 
    , ((modm,                 xK_Left  ), withFocused (keysMoveWindow (-35,0)))         --
    , ((modm,                 xK_Right ), withFocused (keysMoveWindow (35,0)))          --
    , ((modm .|. shiftMask,   xK_Up    ), withFocused (keysResizeWindow (0,-30) (0,0))) -- resize floating window
    , ((modm .|. shiftMask,   xK_Down  ), withFocused (keysResizeWindow (0,30) (0,0)))  --
    , ((modm .|. shiftMask,   xK_Left  ), withFocused (keysResizeWindow (-30,0) (0,0))) --
    , ((modm .|. shiftMask,   xK_Right ), withFocused (keysResizeWindow (30,0) (0,0)))  --
    , ((modm .|. controlMask, xK_Left  ), withFocused $ snapMove L Nothing)             -- snap window relative to window or desktop
    , ((modm .|. controlMask, xK_Right ), withFocused $ snapMove R Nothing)             --
    , ((modm .|. controlMask, xK_Up    ), withFocused $ snapMove U Nothing)             --
    , ((modm .|. controlMask, xK_Down  ), withFocused $ snapMove D Nothing)             --
    , ((modm .|. altMask,     xK_Left  ), withFocused $ snapGrow L Nothing)             -- snap window size to relative to other windows or desktop
    , ((modm .|. altMask,     xK_Right ), withFocused $ snapGrow R Nothing)             --
    , ((modm .|. altMask,     xK_Up    ), withFocused $ snapGrow U Nothing)             --
    , ((modm .|. altMask,     xK_Down  ), withFocused $ snapGrow D Nothing)             --

    -- // system commands
    , ((modm,                      xK_b ), sendMessage ToggleStruts)                                                                  -- toggle xmobar to front of screen
    , ((modm,                      xK_q ), confirmPrompt logoutPrompt "recompile?" $ spawn "xmonad --recompile && xmonad --restart")  -- recompiles xmonad
    , ((modm,                 xK_Escape ), confirmPrompt logoutPrompt "logout?" $ io (exitWith ExitSuccess))                          -- logout from xmonad
    , ((modm .|. shiftMask,   xK_Escape ), confirmPrompt logoutPrompt "sleep?" $ spawn "systemctl suspend")                           -- sleep mode
    , ((modm .|. altMask,     xK_Escape ), confirmPrompt logoutPrompt "reboot?" $ spawn "systemctl reboot")                           -- reboot computer
    , ((modm .|. controlMask, xK_Escape ), confirmPrompt logoutPrompt "shutdown?" $ spawn "systemctl poweroff")                       -- shutdown computer
    , ((0,       xF86XK_MonBrightnessUp ), spawn "lux -a 5%")                                                                         -- change brightness
    , ((0,     xF86XK_MonBrightnessDown ), spawn "lux -s 5% -m 1000")                                                                 --
    , ((modm,                      xK_l ), spawn "xscreensaver-command -lock")                                                        -- lock system
    , ((0,      xF86XK_AudioRaiseVolume ), spawn "pamixer -i 5")                                                                      -- change volume
    , ((0,      xF86XK_AudioLowerVolume ), spawn "pamixer -d 5")                                                                      --
    , ((0,             xF86XK_AudioMute ), spawn "pamixer -t")                                                                        --

    -- // playerctl
    , ((0,             xF86XK_AudioPlay  ), spawn $ "playerctl play-pause " ++ playerctlPlayers)               -- play-pause player
    , ((0,             xF86XK_AudioPause ), spawn $ "playerctl pause " ++ playerctlPlayers)                    -- pause player
    , ((0,             xF86XK_AudioStop  ), spawn $ "playerctl stop " ++ playerctlPlayers)                     -- stop player
    , ((0,             xF86XK_AudioPrev  ), spawn $ "playerctl previous " ++ playerctlPlayers)                 -- previous song/video/track
    , ((0,             xF86XK_AudioNext  ), spawn $ "playerctl next " ++ playerctlPlayers)                     -- next song/video/track

    -- // programs
    , ((modm .|. shiftMask, xK_Return ), spawn $ XMonad.terminal conf)                               -- open terminal
    , ((modm .|. shiftMask,      xK_s ), spawn "flameshot gui")                                      -- equivelent to prntscr
    , ((modm,                    xK_r ), spawn "dmenu_run -b -nb black -nf white")                   -- run program
    , ((modm .|. shiftMask,      xK_c ), qalcPrompt qalcPromptConfig "qalc (Press esc to exit)" )    -- quick calculator
    , ((modm .|. shiftMask,      xK_k ), spawn "~/Scripts/toggle_screenkey.sh")                      -- toggle screenkey off and on
    , ((0,          xF86XK_TouchpadOn ), spawn "~/Scripts/enable_touchpad.sh")                       -- toggle touchpad off and on
    , ((0,         xF86XK_TouchpadOff ), spawn "~/Scripts/disable_touchpad.sh")                      -- 
    
    -- // scratchpad
    , ((modm .|. controlMask, xK_Return ), namedScratchpadAction myScratchpads "ScrP_alacritty")
    , ((modm .|. shiftMask,    xK_slash ), namedScratchpadAction myScratchpads "help")
    , ((modm,                  xK_grave ), namedScratchpadAction myScratchpads "ScrP_htop")
    , ((modm .|. shiftMask,    xK_grave ), namedScratchpadAction myScratchpads "ScrP_ncdu")
    , ((modm,                      xK_v ), namedScratchpadAction myScratchpads "ScrP_vim")
    , ((modm,                      xK_m ), namedScratchpadAction myScratchpads "ScrP_cmus")
    , ((modm .|. shiftMask,        xK_b ), namedScratchpadAction myScratchpads "ScrP_blueman")
    , ((modm .|. shiftMask,        xK_v ), namedScratchpadAction myScratchpads "ScrP_alsamixer")
    , ((modm .|. controlMask,      xK_v ), namedScratchpadAction myScratchpads "ScrP_pavucontrol")

    -- // grid
    , ((modm,                  xK_Tab ), goToSelected $ gridSystemColor systemColorizer)
    , ((modm,                    xK_f ), spawnSelected' myGridSpawn)
    ]
    ++
    -- mod-[1..9] = Switch to workspace 
    -- mod-shift-[1..9] = Move window to workspace
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
 


---------------------------------------------------------
-- Layouts
-- > A list of layouts, use [mod-space] to cycle layouts. 
--                          [mod-shift-space] to go back to the first layout (In this case, full).
---------------------------------------------------------

myLayout = avoidStruts (renamed [CutWordsLeft 2] $ spacingWithEdge 6 $ hiddenWindows $ smartBorders 
         ( full ||| htiled ||| vtiled ||| hthreecol ||| vthreecol ||| grid ||| lspiral ) ||| circle ) 
        
    where
        full = renamed [Replace "<fc=#909090>\xeb4c</fc> Full"] $ Full
        
        htiled = renamed [Replace "<fc=#909090>\xebc8</fc> Tiled"] $ Tall nmaster delta ratio
        vtiled = renamed [Replace "<fc=#909090>\xf0c9</fc> Tiled"] $ Mirror $ Tall nmaster delta ratio
        nmaster = 1
        delta = 3/100
        ratio = 1/2
        
        hthreecol = renamed [Replace "<fc=#909090>\xfa6c</fc> ThreeCol"] $ ThreeCol cnmaster cdelta cratio
        vthreecol = renamed [Replace "<fc=#909090>\xfd33</fc> ThreeCol"] $ Mirror $ ThreeCol cnmaster cdelta cratio
        cnmaster = 1
        cdelta = 3/100
        cratio = 1/2
        
        grid = renamed [Replace "<fc=#909090>\xfc56</fc> Grid"] $ Grid
        
        lspiral = renamed [Replace "<fc=#909090>\xe206</fc> Spiral"] $ spiral (6/7)

        circle = renamed [Replace "<fc=#909090>\xf10c</fc> Circle"] $ Circle



---------------------------------------------------------
-- Scratchpads
-- > Spawns a floating window on the screen.
--   Useful for when you want to quickly access an application and leave it running in the background.
---------------------------------------------------------

myScratchpads = 
         [ NS "help"                "alacritty -t \"list of programs\" -e ~/.config/xmonad/scripts/help.sh" (title =? "list of programs") floatScratchpad
         , NS "ScrP_alsamixer"      "alacritty -t alsamixer -e alsamixer"   (title =? "alsamixer")          floatScratchpad
         , NS "ScrP_alacritty"      "alacritty -t scratchpad"               (title =? "scratchpad")         floatScratchpad
         , NS "ScrP_htop"           "alacritty -t htop -e htop"             (title =? "htop")               floatScratchpad
         , NS "ScrP_vim"            "alacritty -t vim -e vim"               (title =? "vim")                floatScratchpad
         , NS "ScrP_ncdu"           "alacritty -t ncdu -e ncdu"             (title =? "ncdu")               floatScratchpad
         , NS "ScrP_cmus"           "alacritty -t cmus -e cmus"             (title =? "cmus")               floatScratchpad
         , NS "ScrP_blueman"        "blueman-manager"                       (resource =? "blueman-manager") floatScratchpad
         , NS "ScrP_pavucontrol"    "pavucontrol"                           (resource =? "pavucontrol")     floatScratchpad
         ]
    where 
        floatScratchpad = customFloating $ W.RationalRect l t w h
                where
                    w = 0.9
                    h = 0.88
                    l = 0.94 - h
                    t = 0.98 - w



---------------------------------------------------------
-- Prompts
-- > Configs for prompts used for keybindings in [Key Binds].
---------------------------------------------------------

qalcPromptConfig :: XPConfig
qalcPromptConfig = def
       { font = "xft: Bitstream Vera Sans Mono:size=9:bold:antialias=true:hinting=true"
       , bgColor = "black"
       , fgColor = "white"
       , bgHLight = "white"
       , fgHLight = "black"
       , borderColor = "#646464"
       , position = Bottom 
       , height = 30
       }

logoutPrompt :: XPConfig
logoutPrompt = def 
       { font = "xft: Bitstream Vera Sans Mono:size=9:bold:antialias=true:hinting=true"
       , bgColor = "black"
       , fgColor = "white"
       , bgHLight = "white"
       , fgHLight = "black"
       , borderColor = "white"
       , height = 50
       , position = CenteredAt (0.5) (0.5)
       }



---------------------------------------------------------
-- Hooks
-- > xmonad hooks for managing windows, applications, and workspaces.
---------------------------------------------------------

        -- This handles newly created windows.
myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll

        -- > doFloat to open in floating mode.
        -- > doCenterFloat to open in flating mode, centered
        -- > doRectFloat to open in floating mode with custom parameters for width, height, x, and y.
        -- > doShift to open only in a specific workspace.

        -- NOTE: This will not work when the workspaces in myWorkspaceList or myWorkspaceWords do not match the workspaces inside doShift. 
        --       Whenever you rename those workspaces, be sure to also rename the workspaces inside doShift.

        -- ter 
        [ title     =? "alacritty"      --> doShift "<action=xdotool key super+1>\xf120</action>"
        
        -- dev
        , className =? "Subl"           --> doShift "<action=xdotool key super+2>\xf121</action>" 
        , className =? "GitHub Desktop" --> doShift "<action=xdotool key super+2>\xf121</action>"  
        , className =? "Arduino IDE"    --> doShift "<action=xdotool key super+2>\xf121</action>"
        
        -- www
        , className =? "firefox"        --> doShift "<action=xdotool key super+3>\xe743</action>" 
        , className =? "Chromium"       --> doShift "<action=xdotool key super+3>\xe743</action>"
        
        -- doc
        , resource  =? "libreoffice"    --> doShift "<action=xdotool key super+4>\xf718</action>"
        , className =? "calibre"        --> doShift "<action=xdotool key super+4>\xf718</action>"
        
        -- vid
        , className =? "obs"            --> doShift "<action=xdotool key super+5>\xf008</action>"
        , className =? "vlc"            --> doShift "<action=xdotool key super+5>\xf008</action>" 
        , className =? "kdenlive"       --> doShift "<action=xdotool key super+5>\xf008</action>" 
        , className =? "Audacity"       --> doShift "<action=xdotool key super+5>\xf008</action>" 
        
        -- game
        , className =? "Steam"          --> doShift "<action=xdotool key super+6>\xf11b</action>"
        , className =? "Pychess"        --> doShift "<action=xdotool key super+6>\xf11b</action>"
        
        -- chat
        , className =? "discord"        --> doShift "<action=xdotool key super+7>\xf1d7</action>" 
        
        -- art
        , className =? "krita"          --> doShift "<action=xdotool key super+9>\xf1fc</action>" 
        , className =? "Gimp"           --> doShift "<action=xdotool key super+9>\xf1fc</action>" 


        -- Places the window in floating mode when opened.
        , className =? "kmix"           --> doFloat
        , className =? "Sxiv"           --> doFloat
        , className =? "Nemo"           --> doCenterFloat
        , className =? "XTerm"          --> doCenterFloat
        , className =? "Pavucontrol"    --> doCenterFloat
        , className =? "Qalculate-gtk"  --> doCenterFloat
        , title     =? "alsamixer"      --> doCenterFloat
        , title     =? "welcome"        --> doRectFloat (W.RationalRect 0.21 0.18 0.56 0.6)
        ]

        -- Spotify's WM_CLASS name is not set when first opening the window, so this is a workaround.
spotifyWindowNameFix = dynamicPropertyChange "WM_NAME" (title =? "Spotify" --> doShift "<action=xdotool key super+8>\xf886</action>") --mus

        -- Event handling. Not quite sure how this works yet.
myEventHook = spotifyWindowNameFix

        -- Executes whenever xmonad starts or restarts.
myStartupHook = do
        spawnOnce "nitrogen --restore &"
        -- spawnOnce "~/Scripts/kyu-kurarin.sh"
        -- spawnOnce "cd GitHub/linux-wallpaperengine/build/ && ./wallengine --silent --fps 20 --screen-root eDP-1 2516038638"
        spawnOnce "picom &"
        spawnOnce "~/.config/xmonad/scripts/startup_window.sh"
        spawnOnce "~/Scripts/battery_notifs.sh &"
        spawnOnce "libinput-gestures &"
        spawnOnce "unclutter &"
        spawnOnce "(eww --config /home/anapal/.config/eww/ open music-widget && /home/anapal/Scripts/eww-fg-workaround.sh) &"
        spawnOnce "xscreensaver --no-splash"
        spawnOnce "$HOME/Scripts/tablet_buttons.sh &"
        setDefaultCursor myCursor

        -- Outputs status information to a status bar.
        -- Useful for status bars like xmobar or dzen.
myLogHook xmproc = dynamicLogWithPP . filterOutWsPP [scratchpadWorkspaceTag] $ def
                                   { ppOutput = hPutStrLn xmproc
                                   , ppCurrent = xmobarColor "#4381fb" "" . wrap "[" "]"
                                   , ppVisible = xmobarColor "#4381fb" ""
                                   , ppHidden = xmobarColor "#d1426e" "" . wrap "" ""
                                   , ppHiddenNoWindows = xmobarColor "#061d8e" ""
                                   , ppTitle = xmobarColor "#ffffff" "" . shorten 50
                                   , ppSep = "<fc=#666666> | </fc>"
                                   , ppWsSep = "<fc=#666666> . </fc>"
                                   , ppExtras = [windowCount]
                                   , ppOrder = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                                   } 



---------------------------------------------------------
-- XMonad Main
-- > Where xmonad loads everything. 
-- > Hypothetically, you can probably pack everything into here, but I haven't tried it yet.
---------------------------------------------------------

main = do
   xmproc <- spawnPipe "xmobar -x 0 ~/.xmobarrc/xmobar.hs"
   xmonad $ docks $ ewmhFullscreen . ewmh $ desktopConfig
        { terminal           = myTerminal
        , modMask            = myModMask
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor

        , keys               = myKeys

        , layoutHook         = myLayout
        , manageHook         = myManageHook <+> namedScratchpadManageHook myScratchpads
        , handleEventHook    = myEventHook
        , logHook            = myLogHook xmproc >> setWMName "LG3D"

        , startupHook        = myStartupHook
     }



---------------------------------------------------------
-- Functions
-- > These are used for certain functions in some parts of this config. 
---------------------------------------------------------

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset


toggleFloat :: Window -> X ()
toggleFloat w = windows
   ( \s -> if M.member w (W.floating s)
           then W.sink w s
           else (W.float w toggleFloatSize) s)


xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
   where
           doubleLts '<' = "<<"
           doubleLts x   = [x]


    -- This function is special as a template for other programs
    -- since you can insert any program here that accepts a single line of input
    -- and outputs another.
qalcPrompt :: XPConfig -> String -> X () 
qalcPrompt c ans =
    inputPrompt c (trim ans) ?+ \input -> 
        liftIO(runProcessWithInput "qalc" [input] "") >>= qalcPrompt c 
    where
        trim  = f . f
            where f = reverse . dropWhile isSpace


gridSystemColor colorizer = (buildDefaultGSConfig colorizer) { gs_cellheight = 60, 
                                                               gs_cellwidth = 150,
                                                               gs_font = "xft:Iosevka:size=10:bold:antialias=true:hinting=true, Symbols Nerd Font:size=11" }

    -- Grid color for goToSelected used in [Key Binds].
systemColorizer = colorRangeFromClassName
                     minBound            -- lowest inactive bg
                     minBound            -- highest inactive bg
                     (0x2a,0x50,0x9a)    -- active bg
                     maxBound            -- inactive fg
                     maxBound            -- active fg

    -- Grid color for spawnSelected used in [Key Binds].
stringColorizer' :: String -> Bool -> X (String, String)
stringColorizer' s active = if active then 
                                pure ("#2a509a", "white")
                             else
                                pure ("black", "white")


spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
                    where conf = (gridSystemColor stringColorizer')
