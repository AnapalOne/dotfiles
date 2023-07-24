---------------------------------------------------------
--            xmonad config by Anapal                  --
--     My personal config for my (or your) needs.      --
--                                                     --
--      > https://github.com/AnapalOne/dotfiles        --
---------------------------------------------------------

import XMonad

import Control.Monad (when)
-- import Graphics.X11.ExtraTypes.XF86

import Data.Monoid
import Data.Char (isSpace)
import Data.Maybe (isJust, fromMaybe, fromJust)

import System.Exit (exitWith, ExitCode(ExitSuccess))
import System.Process (readProcess)

import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.ConfirmPrompt

import XMonad.Config.Desktop

import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS
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
-- TODO: import XMonad.Hooks.ScreenCorners

import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad
import XMonad.Util.Cursor

import qualified XMonad.Actions.FlexibleResize as Flex
import qualified XMonad.Util.Hacks             as Hacks (trayerPaddingXmobarEventHook, trayerAboveXmobarEventHook)
import qualified XMonad.StackSet               as W
import qualified Data.Map                      as M
import qualified Data.Map.Strict               as Map



----------------------------------------------------------------------------
-- Configs
-- > For quick configuration without scrolling the entire config file. 
----------------------------------------------------------------------------

myTerminal              = "alacritty"
myModMask               = mod4Mask -- win key

myBorderWidth        = 3
myNormalBorderColor  = "#849DAB"
myFocusedBorderColor = "#24788F"

    -- Size and position of window when it is toggled into floating mode.
toggleFloatSize = (W.RationalRect (0.01) (0.06) (0.50) (0.50))

    -- Applications in spawnSelected. (Home or modm + f)
myGridSpawn = [ ("\xf121 Sublime Text",   "subl"), 
                ("\xf269 Firefox",        "firefox"), 
                ("\xea84 Github Desktop", "github-desktop"),
                ("\xf0dc8 LibreOffice",   "libreoffice"), 
                ("\xf07b Nemo",           "nemo"), 
                ("\xf008 Kdenlive" ,      "kdenlive"),
                ("\xf066f Discord",       "discord"),
                ("\xf1bc Spotify",        "spotify-launcher"), 
                ("\xf03e GIMP",           "gimp"), 
                ("\xf1fc Krita",          "krita"), 
                ("\xf03d OBS",            "obs"),
                ("\xf028 Audacity",       "audacity"), 
                ("\xf11b Steam",          "steam")
              ]



----------------------------------------------------------------------------
-- Workspaces
-- > 9 workspaces for the terminal, development tools/software, 
--   browsers, documents (libreoffice or msoffice), videos, gaming, 
--   messaging apps (discord, messenger, etc), music, and art.
----------------------------------------------------------------------------

myWorkspaces :: [String]
myWorkspaces = ["\xf120", "\xf121", "\xf0239", "\xf0219", "\xf03d", "\xf11b", "\xf1d7", "\xf0388", "\xf1fc"] -- Icons.
-- myWorkspaces = ["ter", "dev", "www", "doc", "vid", "game", "chat", "mus", "art"] -- Words.



----------------------------------------------------------------------------
-- Key Binds
-- > These are keybindings that I use for navigating in xmonad. 
-- 
-- > [mod-ctrl-slash] to display key bindings. 
-- > Do "xev | sed -ne '/^KeyPress/,/^$/p'" for key mappings.
----------------------------------------------------------------------------

altMask :: KeyMask
altMask = mod1Mask

playerctlPlayers = "--player=spotify,cmus,spotifyd"

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
 
    -- // windows
    [ ((modm,               xK_BackSpace ), kill)                               -- close focused window
    , ((modm,               xK_space     ), sendMessage NextLayout)             -- rotate layout
    , ((modm .|. shiftMask, xK_space     ), setLayout $ XMonad.layoutHook conf) -- reset layout order
    , ((altMask,            xK_Tab       ), windows W.focusUp)                  -- rotate focus between windows
    , ((modm,               xK_Return    ), windows W.swapMaster)               -- swap focus master and window
    , ((modm .|. shiftMask, xK_comma     ), sendMessage Shrink)                 -- decreases master window size
    , ((modm .|. shiftMask, xK_period    ), sendMessage Expand)                 -- increases master window size
    , ((modm,               xK_comma     ), windows W.swapUp)                   -- move tiled window
    , ((modm,               xK_period    ), windows W.swapDown)                 --
    , ((modm,               xK_backslash ), withFocused hideWindow)             -- hide window
    , ((modm .|. shiftMask, xK_backslash ), popOldestHiddenWindow)              -- restore the last hidden window
    ] ++

    -- // workspaces
    [ ((modm,            xK_Home ), prevWS)                    -- switch workspace to the left
    , ((modm,            xK_End  ), nextWS )                   -- switch workspace to the right
    ] ++

    -- // floating windows
    [ ((modm .|. shiftMask,   xK_Tab   ), withFocused toggleFloat)                      -- toggle between tiled and floating window
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
    , ((modm .|. altMask,     xK_Left  ), withFocused $ snapGrow L Nothing)             -- snap window size relative to other windows or the desktop
    , ((modm .|. altMask,     xK_Right ), withFocused $ snapGrow R Nothing)             --
    , ((modm .|. altMask,     xK_Up    ), withFocused $ snapGrow U Nothing)             --
    , ((modm .|. altMask,     xK_Down  ), withFocused $ snapGrow D Nothing)             --
    ] ++

    -- // system commands
    [ ((modm,                               xK_b      ), sendMessage ToggleStruts)                                                                 -- toggle xmobar visibility
    , ((modm,                               xK_q      ), confirmPrompt configPrompt "recompile?" $ spawn "xmonad --recompile && xmonad --restart") -- recompiles xmonad
    , ((modm,                               xK_Escape ), confirmPrompt configPrompt "logout?" $ io (exitWith ExitSuccess))                         -- logout from xmonad
    , ((modm .|. controlMask,               xK_Escape ), confirmPrompt configPrompt "shutdown?" $ spawn "systemctl poweroff")                      -- shutdown computer
    , ((modm .|. shiftMask,                 xK_Escape ), confirmPrompt configPrompt "sleep?" $ spawn "systemctl suspend")                          -- sleep mode
    , ((modm .|. altMask,                   xK_Escape ), confirmPrompt configPrompt "reboot?" $ spawn "systemctl reboot")                          -- reboot computer
    , ((modm .|. shiftMask .|. controlMask, xK_Escape ), confirmPrompt configPrompt "hibernation?" $ spawn "systemctl hibernate")                  -- hibernate computer
    , ((modm,                               xK_equal  ), spawn "pamixer -i 5")                                                                     -- increase volume
    , ((modm,                               xK_minus  ), spawn "pamixer -d 5")                                                                     -- decrease volume
    , ((modm,                               xK_0      ), spawn "pamixer -t")                                                                       -- mute volume
    ] ++

    -- // playerctl
    [ ((modm,             xK_apostrophe   ), spawn $ "playerctl play-pause " ++ playerctlPlayers)  -- play-pause player
    , ((modm,             xK_bracketright ), spawn $ "playerctl next " ++ playerctlPlayers)        -- next song/video/track
    , ((modm,             xK_bracketleft  ), spawn $ "playerctl previous " ++ playerctlPlayers)    -- previous song/video/track
    ] ++

    -- // programs
    [ ((modm .|. shiftMask, xK_Return ), spawn $ XMonad.terminal conf)                            -- open terminal
    , ((modm .|. shiftMask,      xK_s ), spawn "flameshot gui")                                   -- equivelent to prntscr
    , ((modm,                    xK_r ), spawn "dmenu_run -b -nb black -nf white")                -- run program
    , ((modm .|. shiftMask,      xK_v ), spawn "alacritty -t alsamixer -e alsamixer")             -- sound system
    , ((modm .|. shiftMask,      xK_k ), spawn "~/Scripts/toggle_screenkey.sh")                   -- toggle screenkey off and on
    , ((modm .|. shiftMask,      xK_c ), qalcPrompt qalcPromptConfig "qalc (Press esc to exit)" ) -- quick calculator
    , ((modm,                    xK_n ), spawn "~/Scripts/toggle_oneko.sh -neko")                 -- nyeko
    , ((modm .|. shiftMask,      xK_n ), spawn "~/Scripts/toggle_oneko.sh -dog")                  -- doggo
    , ((modm .|. controlMask,    xK_n ), spawn "~/Scripts/toggle_oneko.sh -sakura")               -- amine
    ] ++
    
    -- // scratchpad
    [ ((modm .|. controlMask, xK_Return ), namedScratchpadAction myScratchpads "ScrP_alacritty") -- spawns alacritty 
    , ((modm .|. shiftMask,    xK_slash ), namedScratchpadAction myScratchpads "help")           -- spawns list of programs
    , ((modm,                  xK_grave ), namedScratchpadAction myScratchpads "ScrP_htop")      -- spawns htop window
    , ((modm .|. shiftMask,    xK_grave ), namedScratchpadAction myScratchpads "ScrP_ncdu")      -- spawns ncdu window
    , ((modm,                      xK_v ), namedScratchpadAction myScratchpads "ScrP_vim")       -- spawns vim window
    , ((modm,                      xK_m ), namedScratchpadAction myScratchpads "ScrP_cmus")      -- spawns cmus window
    , ((modm .|. shiftMask,        xK_m ), namedScratchpadAction myScratchpads "ScrP_spt")       -- spawns spotify-tui window
    , ((modm .|. controlMask,  xK_slash ), namedScratchpadAction myScratchpads "keybindings")    -- spawns list of xmonad keybindings
    ] ++

    -- // grid
    [ ((modm,                  xK_Tab ), goToSelected $ gridSystemColor systemColorizer) -- opens grid with currently opened applications
    , ((0,                    xK_Menu ), spawnSelected' myGridSpawn)                     -- opens grid with programs defined in 'myGridSpawn'
    ] ++

    -- // workspace navigation
    -- mod-[1..9]         = Switch to workspace 
    -- mod-shift-[1..9]   = Move window to workspace
    -- mod-control-[1..9] = Move window to workspace and switch to that workspace
    [ ((modm .|. m, k), changeWorkspaces f i z t)
        | (i, k) <- zip (myWorkspaces) [xK_1 .. xK_9]
        , (f, m, z, t) <- [ (W.greedyView, 0, False, 0), -- [ (Action, Mask, WithNotifications) ]
                            (W.shift, shiftMask, True, 1), 
                            (\i -> W.greedyView i . W.shift i, controlMask, True, 2) ]
    ] 
        where 
            changeWorkspaces f i z t = do
                stackset <- gets windowset
                when (z && currentWSHasWindow stackset) $ notifyWS
                windows $ f i
                    where 
                        notifyWS = do
                            wn <- runProcessWithInput "xdotool" ["getactivewindow", "getwindowname"] ""
                            
                            let rstrip = reverse . dropWhile isSpace . reverse
                            let parseSlash = map (\x -> if x == '\'' then '`'; else x) -- an apostrophe breaks the command inside 'spawn', so replace with a backtick
                            let wnShort = parseSlash . rstrip $ shorten 40 (wn)
                            let notifyWSArgs = "-u low -h string:x-canonical-private-synchronous:wsMove -a 'xmonad workspaces'" 
                            
                            case t of 
                                1 -> spawn ("notify-send " ++ notifyWSArgs ++ " 'Moving [" ++ wnShort ++ "] to '" ++ i)
                                2 -> spawn ("notify-send " ++ notifyWSArgs ++ " 'Moving [" ++ wnShort ++ "] and shifting to '" ++ i)

                        windowsPresent, currentWSHasWindow :: WindowSet -> Bool
                        windowsPresent = null . W.index . W.view i
                        currentWSHasWindow = isJust . W.peek


myMouseBinds conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- // mouse bindings
    [ ((modm,   button1), (\w -> focus w >> mouseMoveWindow w >> windows W.swapMaster)) -- move window and send to top of stack
    , ((modm,   button3), (\w -> focus w >> Flex.mouseResizeEdgeWindow (0.5) w))        -- resize window with right mouse button at window edge
    ]
        


----------------------------------------------------------------------------
-- Layouts
-- > A list of layouts, use [mod-space] to cycle layouts. 
--                          [mod-shift-space] to go back to the first layout (In this case, full).
----------------------------------------------------------------------------

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



----------------------------------------------------------------------------
-- Scratchpads
-- > Spawns a floating window on the screen.
--   Useful for when you want to quickly access an application and leave it running in the background.
----------------------------------------------------------------------------

myScratchpads = 
         [ NS "help"                "alacritty -t 'list of programs' -e ~/.config/xmonad/scripts/help.sh" (title =? "list of programs") floatScratchpad
         , NS "keybindings"         "alacritty -t 'xmonad keybindings' -e ~/.config/xmonad/scripts/show-keybindings.sh" (title =? "xmonad keybindings") helpScratchpad
         , NS "ScrP_ncdu"           "alacritty -t ncdu -e ncdu --exclude /home/anapal/HDD/" (title =? "ncdu") floatScratchpad
         , NS "ScrP_alacritty"      "alacritty -t scratchpad"           (title =? "scratchpad")     floatScratchpad
         , NS "ScrP_htop"           "alacritty -t htop -e htop"         (title =? "htop")           floatScratchpad
         , NS "ScrP_vim"            "alacritty -t vim -e vim"           (title =? "vim")            floatScratchpad
         , NS "ScrP_cmus"           "alacritty -t cmus -e cmus"         (title =? "cmus")           floatScratchpad
         , NS "ScrP_spt"            "alacritty -t spotify-tui -e spt"   (title =? "spotify-tui")    floatScratchpad
         ]
    where 
       floatScratchpad = customFloating $ W.RationalRect l t w h
                where
                    w = 0.9
                    h = 0.88
                    l = 0.94 - h
                    t = 0.98 - w

       helpScratchpad = customFloating $ W.RationalRect lh th wh hh
                where
                    wh = 0.39
                    hh = 0.88
                    lh = 0.90 - hh
                    th = 0.45 - wh



----------------------------------------------------------------------------
-- Prompts
-- > Configs for prompts used for keybindings in [Key Binds].
----------------------------------------------------------------------------

qalcPromptConfig :: XPConfig
qalcPromptConfig = def
       { font = "xft: Bitstream Vera Sans Mono:size=8:bold:antialias=true:hinting=true"
       , bgColor = "black"
       , fgColor = "white"
       , bgHLight = "white"
       , fgHLight = "black"
       , borderColor = "#646464"
       , position = Bottom 
       , height = 30
       }

configPrompt :: XPConfig
configPrompt = def 
       { font = "xft: Bitstream Vera Sans Mono:size=8:bold:antialias=true:hinting=true"
       , bgColor = "black"
       , fgColor = "white"
       , bgHLight = "white"
       , fgHLight = "black"
       , borderColor = "white"
       , height = 50
       , position = CenteredAt (0.5) (0.5)
       }



----------------------------------------------------------------------------
-- Hooks
-- > xmonad hooks for managing windows, applications, and workspaces.
----------------------------------------------------------------------------

        -- This handles newly created windows.
myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll

        -- > doFloat to open in floating mode.
        -- > doCenterFloat to open in flating mode, centered
        -- > doRectFloat to open in floating mode with custom parameters for width, height, x, and y.
        -- > doShift to open only in a specific workspace.

        -- ter 
        [ title     =? "alacritty"      --> doShift ( myWorkspaces !! 0 )
        
        -- dev
        , className =? "Subl"           --> doShift ( myWorkspaces !! 1 )
        , className =? "GitHub Desktop" --> doShift ( myWorkspaces !! 1 )
        
        -- www
        , className =? "firefox"        --> doShift ( myWorkspaces !! 2 )
        , className =? "Chromium"       --> doShift ( myWorkspaces !! 2 )
        
        -- doc
        , resource  =? "libreoffice"    --> doShift ( myWorkspaces !! 3 )
        , className =? "calibre"        --> doShift ( myWorkspaces !! 3 )
        
        -- vid
        , className =? "obs"            --> doShift ( myWorkspaces !! 4 )
        , className =? "vlc"            --> doShift ( myWorkspaces !! 4 )
        , className =? "kdenlive"       --> doShift ( myWorkspaces !! 4 )
        , className =? "Audacity"       --> doShift ( myWorkspaces !! 4 )
        
        -- game
        , className =? "steam"          --> doShift ( myWorkspaces !! 5 )
        
        -- chat
        , className =? "discord"        --> doShift ( myWorkspaces !! 6 )

        -- mus
        , className =? "Spotify"        --> doShift ( myWorkspaces !! 7 )

        -- art
        , className =? "krita"          --> doShift ( myWorkspaces !! 8 )
        , className =? "Gimp"           --> doShift ( myWorkspaces !! 8 )

        -- Places the window in floating mode.
        , title     =? "welcome"        --> doCenterFloat
        , title     =? "alsamixer"      --> doCenterFloat
        , className =? "Nemo"           --> doCenterFloat
        , className =? "XTerm"          --> doCenterFloat
        , className =? "KeyOverlay"     --> doCenterFloat
        , className =? "Sxiv"           --> doFloat

        , title =? "Eww - music-widget" --> doIgnore
        ]
        
        -- This controls all events that are handled by xmonad.
myEventHook = mempty


        -- Executes whenever xmonad starts or restarts.
myStartupHook = do
        spawnOnce "nitrogen --restore &"
        -- spawnOnce "/home/anapal/GitHub/linux-wallpaperengine/build/wallengine --screen-root DVI-D-0 --fps 15 2516038638"
        spawnOnce "picom &"
        spawnOnce "~/.config/xmonad/scripts/startup_window.sh"
        spawnOnce "unclutter &"
        spawnOnce "eww open music-widget --config /home/anapal/.config/eww/ &"

        -- TODO:
        -- Remake eww-music-widget to not interfere with windows in inactivity
        -- && ~/Scripts/eww-fg-workaround.sh 

        spawnOnce "flameshot &"
        spawnOnce "$HOME/Scripts/tablet_buttons.sh &"
        spawnOnce "trayer --edge top --align right --distancefrom top --distance 16 --SetDockType true --SetPartialStrut true --height 22 --widthtype request --padding 5 --margin 20 --transparent true --alpha 0 --tint 0x000000 --iconspacing 3 -l"
        spawn "xsetroot -cursor_name left_ptr"


        -- When the stack of windows managed by xmonad has been changed.
        -- Useful for displaying information to status bars like xmobar or dzen.
myLogHook xmproc = dynamicLogWithPP . filterOutWsPP [scratchpadWorkspaceTag] $ xmobarPP
                                   { ppOutput = hPutStrLn xmproc 
                                   , ppCurrent = xmobarColor "#4381fb" "" . wrap "[" "]"
                                   , ppHidden = xmobarColor "#d1426e" "" . clickableWS
                                   , ppHiddenNoWindows = xmobarColor "#061d8e" "" . clickableWS
                                   , ppTitle = xmobarColor "#ffffff" "" . shorten 50
                                   , ppSep = "<fc=#909090> | </fc>"
                                   , ppWsSep = "<fc=#666666> . </fc>"
                                   , ppExtras = [windowCount] 
                                   , ppOrder = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                                   }



----------------------------------------------------------------------------
-- XMonad Main
-- > Where xmonad loads everything. 
-- > Hypothetically, you can probably pack everything into here, but I haven't tried it yet.
----------------------------------------------------------------------------

main :: IO()
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
        , mouseBindings      = myMouseBinds

        , layoutHook         = myLayout
        , manageHook         = myManageHook <+> namedScratchpadManageHook myScratchpads
        , handleEventHook    = myEventHook <> Hacks.trayerPaddingXmobarEventHook <> Hacks.trayerAboveXmobarEventHook
        , logHook            = myLogHook xmproc 

        , startupHook        = myStartupHook
     }



----------------------------------------------------------------------------
-- Functions
-- > These are used for certain functions in some parts of this config. 
----------------------------------------------------------------------------

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


    -- This function is special as a template for other usages 
    -- since you can insert any program that accepts a signle line of input
    -- and outputs another.
qalcPrompt :: XPConfig -> String -> X () 
qalcPrompt c ans =
    inputPrompt c (trim ans) ?+ \input -> 
        liftIO(runProcessWithInput "qalc" [input] "") >>= qalcPrompt c 
    where
        trim  = f . f
            where f = reverse . dropWhile isSpace


gridSystemColor colorizer = (buildDefaultGSConfig colorizer) { gs_cellheight = 50, 
                                                               gs_cellwidth = 130,
                                                               gs_font = "xft:Iosevka:size=9:bold:antialias=true:hinting=true, Symbols Nerd Font:size=10" }

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
                                pure ("#2A509A", "white")
                             else
                                pure ("black", "white")


spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
                    where conf = (gridSystemColor stringColorizer')


clickableWS ws = "<action=xdotool key super+" ++ show i ++ ">" ++ ws ++ "</action>"
    where
        workspaceIndices = Map.fromList $ zipWith (,) myWorkspaces [1..]
        i = fromJust $ Map.lookup ws workspaceIndices
