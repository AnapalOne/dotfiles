---------------------------------------------------------
--            xmonad config by Anapal                  --
--     My personal config for my (or your) needs.      --
--                                                     --
--      > https://github.com/AnapalOne/dotfiles        --
---------------------------------------------------------

import XMonad
import XMonad.ManageHook

import Control.Monad (when)
import Graphics.X11.ExtraTypes.XF86

import Data.Monoid
import Data.Char (isSpace)
import Data.Maybe (isJust, fromMaybe, fromJust)
import Data.List

import System.Exit (exitWith, ExitCode(ExitSuccess))
import System.Process (callProcess)

import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.ConfirmPrompt

import XMonad.Config.Desktop

import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS
import XMonad.Actions.FloatKeys
import XMonad.Actions.FloatSnap
import XMonad.Actions.CopyWindow

import XMonad.Layout.NoBorders
import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing
import XMonad.Layout.CircleEx
import XMonad.Layout.Renamed
import XMonad.Layout.Hidden (hideWindow, popOldestHiddenWindow, hiddenWindows)
import XMonad.Layout.FocusTracking

import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ScreenCorners
import XMonad.Hooks.FadeWindows

import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad
import XMonad.Util.StickyWindows

import qualified XMonad.Actions.FlexibleManipulate as Flex
import qualified XMonad.Util.Hacks                 as H (trayerPaddingXmobarEventHook, trayerAboveXmobarEventHook, fixSteamFlicker)
import qualified XMonad.StackSet                   as W
import qualified Data.Map                          as M
import qualified Data.Map.Strict                   as Map


---------------------------------------------------------
-- Configs
-- > For quick configuration without scrolling the entire config file. 
--   (it's a little tiring for me to find some parts that I want to configure) 
---------------------------------------------------------

myTerminal  = "alacritty"
myModMask   = mod4Mask -- win key
myStatusBar = "xmobar -x 0 ~/.xmobarrc"

myBorderWidth        = 3
myNormalBorderColor  = "#849DAB"
myFocusedBorderColor = "#24788F"

    -- Size and position of window when it is toggled into floating mode.
toggleFloatSize = (W.RationalRect (0.25) (0.25) (0.50) (0.50))

    -- Applications in spawnSelected. (Home or modm + f)
myGridSpawn = [ ("\xe70c VSCode",         "code")
              , ("\xf269 Firefox",        "firefox")
              , ("\xea84 Github Desktop", "github-desktop")
              , ("\xf082e LibreOffice",   "libreoffice")
              , ("\xf07b Nemo",           "nemo")
              , ("\xf008 Kdenlive" ,      "kdenlive")
              , ("\xf066f Discord",       "discord")
              , ("\xf1bc Spotify",        "spotify-launcher")
              , ("\xf338 GIMP",           "gimp")
              , ("\xf1fc Krita",          "krita")
              , ("\xf03d OBS",            "obs")
              , ("\xf04d3 Steam",         "steam")
              , ("\xe6bb Obsidian",       "obsidian")
              , ("\xf370 Thunderbird",    "thunderbird")
              ]

wallpaperDir = "~/Pictures/Wallpapers/Anime/Genshin"


---------------------------------------------------------
-- Workspaces
-- > 9 workspaces for the terminal application, development tools/software, 
--   browsers, documents (libreoffice or msoffice), videos, gaming, 
--   messaging apps (discord, messenger, etc), music, and art.
---------------------------------------------------------

myWorkspaces :: [String]
myWorkspaces = map (\s -> "<fn=2>" ++ s ++ "</fn>")  -- append <fn=2>...</fn> to use 2nd font of additionalFonts in .xmobarrc
               ["\xf120", "\xf121", "\xf059f", "\xf0219", "\xf03d", "\xf11b", "\xf1d7", "\xf001", "\xf1fc"] -- Icons.

-- myWorkspaces = ["ter", "dev", "www", "doc", "vid", "game", "chat", "mus", "art"] -- Words.


---------------------------------------------------------
-- Key Binds
-- > These are keybindings that I use for everything in xmonad. 
--
-- > [mod-ctrl-slash] to display key bindings. 
-- > Do xev | sed -ne '/^KeyPress/,/^$/p' for key maps.
---------------------------------------------------------

altMask :: KeyMask
altMask = mod1Mask

playerctlPlayers = "--player=spotify,cmus,spotifyd"

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
 
    -- // windows
    [ ((modm,                 xK_BackSpace ), kill1)                                -- close focused window
    , ((modm,                 xK_space     ), sendMessage NextLayout)               -- rotate layout
    , ((modm .|. shiftMask,   xK_space     ), setLayout $ XMonad.layoutHook conf)   -- reset layout order
    , ((altMask,              xK_Tab       ), windows W.focusUp     )               -- rotate focus between windows
    , ((modm,                 xK_Return    ), windows W.swapMaster  )               -- swap focus master and window
    , ((modm .|. shiftMask,   xK_comma     ), sendMessage Shrink    )               -- decreases master window size
    , ((modm .|. shiftMask,   xK_period    ), sendMessage Expand    )               -- increases master window size
    , ((modm,                 xK_comma     ), windows W.swapUp      )               -- move tiled window
    , ((modm,                 xK_period    ), windows W.swapDown    )               --
    , ((modm,                 xK_backslash ), withFocused hideWindow <> toggleNotifications "hide")     -- hide window
    , ((modm .|. shiftMask,   xK_backslash ), popOldestHiddenWindow <> toggleNotifications "unhide")    -- restore the last hidden window
    , ((modm,                 xK_c         ), withFocused stick <> toggleNotifications "sticky")       -- copy window to all workspaces
    , ((modm .|. controlMask, xK_c         ), withFocused unstick <> toggleNotifications "unsticky")  -- delete all window copies
    ] ++

    -- // workspaces
    [ ((modm,           xK_Home ),      prevWS)                   -- switch workspace to the left
    , ((modm,            xK_End ),      nextWS)                   -- switch workspace to the right
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
    , ((modm .|. altMask,     xK_Left  ), withFocused $ snapGrow L Nothing)             -- snap window size to relative to other windows or desktop
    , ((modm .|. altMask,     xK_Right ), withFocused $ snapGrow R Nothing)             --
    , ((modm .|. altMask,     xK_Up    ), withFocused $ snapGrow U Nothing)             --
    , ((modm .|. altMask,     xK_Down  ), withFocused $ snapGrow D Nothing)             --
    ] ++

    -- // system commands
    [ ((modm,                                    xK_b ), sendMessage ToggleStruts)                                                                  -- toggle xmobar to front of screen
    , ((modm .|. controlMask,                    xK_b ), toggleScreenSpacingEnabled >> toggleWindowSpacingEnabled)                                  -- toggle gaps          
    , ((modm,                                    xK_q ), confirmPrompt logoutPrompt "recompile?" $ spawn "xmonad --recompile && xmonad --restart")  -- recompiles xmonad
    , ((modm,                               xK_Escape ), confirmPrompt logoutPrompt "logout?" $ spawn "light-locker-command -l")                    -- logout from xmonad
    , ((modm .|. shiftMask,                 xK_Escape ), confirmPrompt logoutPrompt "sleep?" $ spawn "systemctl suspend")                           -- sleep mode
    , ((modm .|. altMask,                   xK_Escape ), confirmPrompt logoutPrompt "reboot?" $ spawn "systemctl reboot")                           -- reboot computer
    , ((modm .|. controlMask,               xK_Escape ), confirmPrompt logoutPrompt "shutdown?" $ spawn "systemctl poweroff")                       -- shutdown computer
    , ((modm .|. controlMask .|. shiftMask, xK_Escape ), confirmPrompt logoutPrompt "hibernate?" $ spawn "systemctl hibernate")                     -- hibernate computer
    , ((0,                     xF86XK_MonBrightnessUp ), changeBrightness 5 >> notifyBrightness)                                                    -- increase brightness
    , ((0,                   xF86XK_MonBrightnessDown ), changeBrightness (-5) >> notifyBrightness)                                                 -- decrease brightness
    , ((0,                    xF86XK_AudioRaiseVolume ), spawn "wpctl set-volume @DEFAULT_SINK@ 5%+" >> notifyVolume)                               -- increase volume
    , ((0,                    xF86XK_AudioLowerVolume ), spawn "wpctl set-volume @DEFAULT_SINK@ 5%-" >> notifyVolume)                               -- decrease volume
    , ((0,                           xF86XK_AudioMute ), spawn "wpctl set-mute @DEFAULT_SINK@ toggle" >> notifyVolume)                              -- mute volume
    ] ++

    -- // playerctl
    [ ((0,             xF86XK_AudioPlay  ), spawn $ "playerctl play-pause " ++ playerctlPlayers)     -- play-pause player
    , ((0,             xF86XK_AudioPause ), spawn $ "playerctl pause " ++ playerctlPlayers)          -- pause player
    , ((0,             xF86XK_AudioStop  ), spawn $ "playerctl stop " ++ playerctlPlayers)           -- stop player
    , ((0,             xF86XK_AudioPrev  ), spawn $ "playerctl previous " ++ playerctlPlayers)       -- previous song/video/track
    , ((0,             xF86XK_AudioNext  ), spawn $ "playerctl next " ++ playerctlPlayers)           -- next song/video/track
    , ((modm,          xK_apostrophe     ), spawn $ "playerctl play-pause " ++ playerctlPlayers)     -- play-pause player
    , ((modm,          xK_bracketleft    ), spawn $ "playerctl previous " ++ playerctlPlayers)       -- previous song/video/track
    , ((modm,          xK_bracketright   ), spawn $ "playerctl next " ++ playerctlPlayers)           -- next song/video/track
    ] ++

    -- // programs
    [ ((modm .|. shiftMask, xK_Return ), spawn $ XMonad.terminal conf)                               -- open terminal
    , ((modm .|. shiftMask,      xK_s ), spawn "flameshot gui")                                      -- screenshot tool
    , ((0,                    xK_Print), spawn "flameshot gui")                                      -- screenshot tool
    , ((modm,                    xK_r ), spawn "dmenu_run -b -nb black -nf white")                   -- run program
    , ((modm .|. shiftMask,      xK_c ), qalcPrompt qalcPromptConfig "qalc (Press esc to exit)" )    -- quick calculator
    , ((modm .|. shiftMask,      xK_k ), spawn "~/Scripts/toggle_screenkey.sh")                      -- toggle screenkey off and on
    , ((0,          xF86XK_TouchpadOn ), spawn "~/Scripts/toggle_touchpad.sh -enable")               -- enable touchpad
    , ((0,         xF86XK_TouchpadOff ), spawn "~/Scripts/toggle_touchpad.sh -disable")              -- disable touchpad
    , ((modm,                    xK_n ), spawn "~/Scripts/toggle_oneko.sh -neko")                    -- nyeko
    , ((modm .|. shiftMask,      xK_n ), spawn "~/Scripts/toggle_oneko.sh -dog")                     -- doggo
    , ((modm .|. controlMask,    xK_n ), spawn "~/Scripts/toggle_oneko.sh -sakura")                  -- amine
    ] ++
    
    -- // scratchpad
    [ ((modm .|. controlMask, xK_Return ), namedScratchpadAction myScratchpads "ScrP_alacritty")    -- spawns alacritty 
    , ((modm .|. shiftMask,    xK_slash ), namedScratchpadAction myScratchpads "help")              -- spawns list of programs
    , ((modm,                  xK_grave ), namedScratchpadAction myScratchpads "ScrP_htop")         -- spawns htop window
    , ((modm .|. shiftMask,    xK_grave ), namedScratchpadAction myScratchpads "ScrP_ncdu")         -- spawns ncdu window
    , ((modm,                      xK_v ), namedScratchpadAction myScratchpads "ScrP_vim")          -- spawns vim window
    , ((modm,                      xK_m ), namedScratchpadAction myScratchpads "ScrP_cmus")         -- spawns cmus window 
    , ((modm .|. shiftMask,        xK_b ), namedScratchpadAction myScratchpads "ScrP_blueman")      -- spawns bluetooth manager 
    , ((modm .|. shiftMask,        xK_v ), namedScratchpadAction myScratchpads "ScrP_alsamixer")    -- spawns spotify-tui window 
    , ((modm .|. controlMask,      xK_v ), namedScratchpadAction myScratchpads "ScrP_pwvucontrol")  -- spawns audio manager 
    , ((modm .|. controlMask,  xK_slash ), namedScratchpadAction myScratchpads "keybindings")       -- spawns list of xmonad keybindings
    ] ++

    -- // grid
    [ ((modm,                  xK_Tab ), goToSelected $ gridSystemColor systemColorizer) -- displays grid with currently opened applicatons
    , ((modm,                    xK_f ), spawnSelected' myGridSpawn)                     -- displays grid with programs defined in 'myGridSpawn'
    ] ++

    -- // workspace navigation
    -- mod-[1..9]         = Switch to workspace 
    -- mod-shift-[1..9]   = Move window to workspace
    -- mod-control-[1..9] = Move window to workspace and switch to that workspace
    -- mod-alt-[1..9]     = Copy window to workspace
    [ ((modm .|. m, k), changeWorkspaces f i z t)
        | (i, k) <- zip (myWorkspaces) [xK_1 .. xK_9]
        , (f, m, z, t) <- [ (W.greedyView,                               0, False, 0) -- [ (Action, Mask, WithNotifications) ]
                          , (W.shift,                            shiftMask, True,  1) 
                          , (\i -> W.greedyView i . W.shift i, controlMask, True,  2)
                          , (copy,                                 altMask, True,  3) ]
    ] 

myMouseBinds conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- // mouse bindings
    [ ((modm,   button1), (\w -> focus w >> mouseMoveWindow w >> windows W.swapMaster)) -- move window and send to top of stack
    , ((modm,   button3), (\w -> focus w >> Flex.mouseWindow Flex.resize w))            -- resize window with right mouse button at window edge
    , ((modm,   button4), (\w -> moveTo Prev $ anyWS :&: ignoreNSP))                    -- switch workspace to the left
    , ((modm,   button5), (\w -> moveTo Next $ anyWS :&: ignoreNSP))                    -- switch workspace to the right
    ]
        where ignoreNSP = ignoringWSs [scratchpadWorkspaceTag]


---------------------------------------------------------
-- Layouts
-- > A list of layouts, use [mod-space] to cycle layouts. 
--                          [mod-shift-space] to go back to the first layout (In this case, full).
---------------------------------------------------------

myLayout = screenCornerLayoutHook $ avoidStruts $ focusTracking (renamed [CutWordsLeft 2] $ spacingWithEdge 6 $ hiddenWindows $ smartBorders 
         ( full ||| htiled ||| vtiled ||| hthreecol ||| vthreecol ||| grid ||| lspiral ) ||| circle ) 
    where
        full = renamed [Replace "<fc=#909090>\xf0e5f</fc> Full"] $ Full
        
        htiled = renamed [Replace "<fc=#909090>\xebc8</fc> Tiled"] $ Tall nmaster delta ratio
        vtiled = renamed [Replace "<fc=#909090>\xf0c9</fc> Tiled"] $ Mirror $ Tall nmaster delta ratio
        nmaster = 1
        delta = 3/100
        ratio = 1/2
        
        hthreecol = renamed [Replace "<fc=#909090>\xf1487</fc> ThreeCol"] $ ThreeColMid cnmaster cdelta cratio
        vthreecol = renamed [Replace "<fc=#909090>\xf0835</fc> ThreeCol"] $ Mirror $ ThreeCol cnmaster cdelta cratio
        cnmaster = 1
        cdelta = 3/100
        cratio = 1/2
        
        grid = renamed [Replace "<fc=#909090>\xf0758</fc> Grid"] $ Grid
        
        lspiral = renamed [Replace "<fc=#909090>\xf0453</fc> Spiral"] $ spiral (6/7)

        circle = renamed [Replace "<fc=#909090>\xf0766</fc> Circle"] $ circleEx {cDelta = -3*pi/4}


---------------------------------------------------------
-- Scratchpads
-- > Spawns a floating window on the screen.
--   Useful for when you want to quickly access an application and leave it running in the background.
---------------------------------------------------------

myScratchpads :: [NamedScratchpad]
myScratchpads = 
         [ NS "help"                "alacritty -t 'list of programs' -e ~/.config/xmonad/scripts/help.sh" (title =? "list of programs") floatScratchpad
         , NS "keybindings"         "alacritty -t 'xmonad keybindings' -e ~/.config/xmonad/scripts/show-keybindings.sh" (title =? "xmonad keybindings") helpScratchpad 
         , NS "ScrP_alsamixer"      "alacritty -t alsamixer -e alsamixer"   (title =? "alsamixer")          floatScratchpad
         , NS "ScrP_alacritty"      "alacritty -t scratchpad"               (title =? "scratchpad")         terminalScratchpad
         , NS "ScrP_htop"           "alacritty -t htop -e htop"             (title =? "htop")               floatScratchpad
         , NS "ScrP_vim"            "alacritty -t vim -e vim"               (title =? "vim")                floatScratchpad
         , NS "ScrP_ncdu"           "alacritty -t ncdu -e ncdu"             (title =? "ncdu")               floatScratchpad
         , NS "ScrP_cmus"           "alacritty -t cmus -e cmus"             (title =? "cmus")               floatScratchpad
         , NS "ScrP_blueman"        "blueman-manager"                       (resource =? "blueman-manager") floatScratchpad
         , NS "ScrP_pwvucontrol"    "pwvucontrol"                           (resource =? "pwvucontrol")     floatScratchpad
         ]
    where 
        floatScratchpad = customFloating $ W.RationalRect l t w h
                where
                    w = 0.9
                    h = 0.88
                    l = 0.94 - h
                    t = 0.98 - w

        terminalScratchpad = customFloating $ W.RationalRect l t w h
                where
                    w = 0.55
                    h = 0.40
                    l = 0.42 
                    t = 0.55

        helpScratchpad = customFloating $ W.RationalRect l t w h
                where
                    w = 0.39
                    h = 0.88
                    l = 0.90 - h
                    t = 0.45 -w


---------------------------------------------------------
-- Prompts
-- > Configs for prompts used for keybindings in [Key Binds].
---------------------------------------------------------

qalcPromptConfig :: XPConfig
qalcPromptConfig = def
       { font        = "xft: Bitstream Vera Sans Mono:size=9:bold:antialias=true:hinting=true"
       , bgColor     = "black"
       , fgColor     = "white"
       , bgHLight    = "white"
       , fgHLight    = "black"
       , borderColor = "#646464"
       , position    = Bottom 
       , height      = 30
       }

logoutPrompt :: XPConfig
logoutPrompt = def 
       { font        = "xft: Bitstream Vera Sans Mono:size=9:bold:antialias=true:hinting=true"
       , bgColor     = "black"
       , fgColor     = "white"
       , bgHLight    = "white"
       , fgHLight    = "black"
       , borderColor = "white"
       , height      = 50
       , position    = CenteredAt (0.5) (0.5)
       }



----------------------------------------------------------------------------
-- Status Bar
-- > Status bar configuration that includes pretty printers.
----------------------------------------------------------------------------

myPP :: PP
myPP = filterOutWsPP [scratchpadWorkspaceTag] $ def
        { ppCurrent = xmobarColor "#4381fb" "" . wrap "[" "]"
        , ppHidden = xmobarColor "#d1426e" "" . clickableWS
        , ppHiddenNoWindows = xmobarColor "#0824ad" "" . clickableWS
        -- , ppVisibleNoWindows = Just $ xmobarColor "#4381fb" "" . wrap "[" "]"
        , ppUrgent = xmobarColor "#fa5c5f" "" . clickableWS
        , ppTitle = xmobarColor "#ffffff" "" . shorten 50 
        , ppSep = "<fc=#909090> | </fc>"
        , ppWsSep = "<fc=#666666> : </fc>"
        , ppExtras = [windowCount] 
        , ppOrder = \(ws:l:t:ex) -> [ws,l]++ex++[t]
        }

mySB :: StatusBarConfig
mySB = statusBarProp myStatusBar
        (copiesPP (xmobarColor "#6435e6" "" . clickableWS) myPP)

statusBarPPLogHook :: X ()
statusBarPPLogHook = dynamicLogWithPP $ myPP 



---------------------------------------------------------
-- Hooks
-- > xmonad hooks for managing windows, applications, and workspaces.
---------------------------------------------------------

myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeOne

        -- > doFloat to open in floating mode.
        -- > doCenterFloat to open in flating mode, centered
        -- > doRectFloat to open in floating mode with custom parameters for width, height, x, and y.
        -- > doShift to open only in a specific workspace.

        -- ter 
        [ title     =? "alacritty"      -?> doShift $ myWorkspaces !! 0
        
        -- dev
        , className =? "code"           -?> doShift $ myWorkspaces !! 1
        , className =? "GitHub Desktop" -?> doShift $ myWorkspaces !! 1
        , className =? "Arduino IDE"    -?> doShift $ myWorkspaces !! 1
        
        -- www
        , className =? "firefox"        -?> doShift $ myWorkspaces !! 2
        , className =? "Chromium"       -?> doShift $ myWorkspaces !! 2
        , className =? "Google-chrome"  -?> doShift $ myWorkspaces !! 2
        
        -- doc
        , resource  =? "libreoffice"    -?> doShift $ myWorkspaces !! 3
        , className =? "calibre"        -?> doShift $ myWorkspaces !! 3
        , className =? "md.obsidian.Obsidian" -?> doShift $ myWorkspaces !! 3
        
        -- vid
        , className =? "obs"            -?> doShift $ myWorkspaces !! 4
        , className =? "vlc"            -?> doShift $ myWorkspaces !! 4 
        , className =? "kdenlive"       -?> doShift $ myWorkspaces !! 4 
        , className =? "Audacity"       -?> doShift $ myWorkspaces !! 4 
        
        -- game
        , className =? "steam"          -?> doShift $ myWorkspaces !! 5
        , className =? "Pychess"        -?> doShift $ myWorkspaces !! 5
        
        -- chat
        , className =? "discord"        -?> doShift $ myWorkspaces !! 6 
        , className =? "Caprine"        -?> doShift $ myWorkspaces !! 6
        , className =? "org.mozilla.Thunderbird" -?> doShift $ myWorkspaces !! 6
  
        -- mus
        , className =? "Spotify"        -?> doShift $ myWorkspaces !! 7 

        -- art
        , className =? "krita"          -?> doShift $ myWorkspaces !! 8
        , className =? "Gimp"           -?> doShift $ myWorkspaces !! 8

          -- Places the window in floating mode when opened.
        , className =? "kmix"                 -?> doFloat
        , className =? "Sxiv"                 -?> doFloat
        , className =? "Nemo"                 -?> doCenterFloat
        , className =? "XTerm"                -?> doCenterFloat
        , className =? "Pavucontrol"          -?> doCenterFloat
        , className =? "Qalculate-gtk"        -?> doCenterFloat
        , className =? "Dragon-drop"          -?> doCenterFloat
        , className =? "zenity"               -?> doCenterFloat
        , appName   =? "iwgtk"                -?> doCenterFloat
        , title     =? "alsamixer"            -?> doCenterFloat
        , title     =? "welcome"              -?> doRectFloat (W.RationalRect 0.21 0.18 0.56 0.65)
        , title =? "todo" <&&> className =? "Alacritty" -?> doCenterFloat
        , role      =? "GtkFileChooserDialog" -?> doCenterFloat
        , isDialog                            -?> doCenterFloat
        ]
        <+> namedScratchpadManageHook myScratchpads
           where
                role = stringProperty "WM_WINDOW_ROLE"

myEventHook :: Event -> X All
myEventHook e = screenCornerEventHook e >> fadeWindowsEventHook e 

myStartupHook :: X ()
myStartupHook = do
        spawnOnce "xdotool mousemove 960 540"

        -- // wallpaper managers
        spawnOnce "~/.fehbg &"
        -- spawnOnce "~/Scripts/kyu-kurarin.sh &"
        -- spawnOnce "cd ~/Programs/linux-wallpaperengine/build/ && ./wallengine --silent --fps 20 --screen-root eDP-1 2621864884 "

        -- // song title and lyric monitor
        spawnOnce "python $HOME/Scripts/sptlrx_lyrics.py &"
        spawnOnce "conky --config=$HOME/.config/conky/conky_todo.conf   &"
        spawnOnce "conky --config=$HOME/.config/conky/conky_lyrics.conf &"

        -- // starting programs
        spawnOnce "picom &"
        spawnOnce "$HOME/.config/xmonad/scripts/startup_window.sh"
        spawnOnce "$HOME/Scripts/battery_notifs.sh &"
        spawnOnce "snixembed --fork"
        --spawnOnce "libinput-gestures &"
        spawnOnce "unclutter &"
        spawnOnce "light-locker --no-lock-on-lid --lock-on-suspend --no-late-locking --idle-hint"
        spawnOnce "$HOME/Scripts/tablet_buttons.sh &"
        spawnOnce ("trayer --edge top --align right --distancefrom top --distance 12 --SetDockType true " ++   
                  "--SetPartialStrut true --height 22 --widthtype request --padding 3 --margin 20 --transparent true " ++
                  "--alpha 0 --tint 0x000000 --iconspacing 3")
        spawn "xsetroot -cursor_name left_ptr"
        spawn "lxsession &"
        spawnOnce "ibus start"
        spawnOnce "iwgtk -i &"
        spawnOnce "blueman-applet &"
        --spawn "otd-daemon &"

        addScreenCorners screenCorners

myLogHook = do
    fadeWindowsLogHook myFadeHook
    statusBarPPLogHook

myFadeHook :: Query Opacity
myFadeHook = composeAll
    [ opaque        -- default, focused windows
    , isUnfocused   --> transparency 0.15
    , isFullscreen  --> opaque
    ]


---------------------------------------------------------
-- XMonad Main
-- > Where xmonad loads everything. 
-- > Hypothetically, you can probably pack everything into here, but I haven't tried it yet.
---------------------------------------------------------

main :: IO()
main = do
   xmonad $ withSB mySB . docks . ewmhFullscreen . ewmh . sticky $ desktopConfig
        { terminal           = myTerminal
        , modMask            = myModMask
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor

        , keys               = myKeys
        , mouseBindings      = myMouseBinds

        , layoutHook         = myLayout
        , manageHook         = myManageHook 
        , handleEventHook    = myEventHook
                                <> H.trayerPaddingXmobarEventHook
                                <> H.trayerAboveXmobarEventHook
                                <> H.fixSteamFlicker
        , logHook            = myLogHook

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

    -- This function is special as a template since you can
    -- insert any program that accepts a signle line of input
    -- and outputs another.
qalcPrompt :: XPConfig -> String -> X () 
qalcPrompt c ans =
    inputPrompt c (trim ans) ?+ \input -> 
        liftIO(runProcessWithInput "qalc" [input] "") >>= qalcPrompt c 
    where
        trim  = f . f
            where f = reverse . dropWhile isSpace

gridSystemColor colorizer = (buildDefaultGSConfig colorizer) 
                            { gs_cellheight = 60 
                            , gs_cellwidth = 150
                            , gs_font = "xft:Iosevka:size=10:bold:antialias=true:hinting=true, Symbols Nerd Font Mono:size=12" 
                            }

    -- Grid color for goToSelected used in [Key Binds].
systemColorizer = colorRangeFromClassName
                     minBound            -- lowest inactive bg
                     minBound            -- highest inactive bg
                     (0x2a,0x50,0x9a)    -- active bg
                     maxBound            -- inactive fg
                     maxBound            -- active fg

    -- Grid color for spawnSelected used in [Key Binds].
stringColorizer' :: String -> Bool -> X (String, String)
stringColorizer' s active = if active then pure ("#2a509a", "white")
                                      else pure ("black", "white")

    -- Modified spawnSelected to include custom program names for GridSelect
spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
                    where conf = (gridSystemColor stringColorizer')

    -- Make workspace names navigable through mouse clicks
clickableWS ws = "<action=xdotool set_desktop " ++ show i ++ ">" ++ ws ++ "</action>"
    where
        workspaceIndices = Map.fromList $ zipWith (,) myWorkspaces [1..]
        i = subtract 1 (fromJust $ Map.lookup ws workspaceIndices)

    -- Modular change workspace function. Currently adds notifications in workspace navigation
changeWorkspaces f i z t = do
    stackset <- gets windowset
    when (z && currentWSHasWindow stackset) notifyWS
    windows $ f i
        where
            notifyWS = do
                wn <- getWindowName

                let notifyWSArgs = "-u low -h string:x-canonical-private-synchronous:wsMove -a 'xmonad workspaces'"
                let workspaceName = take (length i - length "<fn=2>" - length "</fn>") $ drop (length "<fn=2>") i -- remove tags from workspace name

                case t of
                    1 -> spawn ("notify-send " ++ notifyWSArgs ++ " 'Moving [" ++ wn ++ "] to '" ++ workspaceName)
                    2 -> spawn ("notify-send " ++ notifyWSArgs ++ " 'Moving [" ++ wn ++ "] and shifting to '" ++ workspaceName)
                    3 -> spawn ("notify-send " ++ notifyWSArgs ++ " 'Copying [" ++ wn ++ "] to '" ++ workspaceName)

            windowsPresent, currentWSHasWindow :: WindowSet -> Bool
            windowsPresent = null . W.index . W.view i
            currentWSHasWindow = isJust . W.peek

    -- Family function for notifications on event
toggleNotifications :: String -> X ()
toggleNotifications x = do
    wn <- getWindowName

    let hideNotifyArgs   = "-u low -h string:x-canonical-private-synchronous:wHide -a 'hide windows'"
    let copyNotifyArgs   = "-u low -h string:x-canonical-private-synchronous:wCopy -a 'copy windows'"
    let stickyNotifyArgs = "-u low -h string:x-canonical-private-synchronous:wSticky -a 'sticky windows'"

    case x of
        -- XMonad.Layout.Hidden, but with notifications.
        "hide"   -> spawn ("notify-send " ++ hideNotifyArgs ++ " 'Window [" ++ wn ++ "] hidden.'")
        "unhide" -> spawn ("notify-send " ++ hideNotifyArgs ++ " 'Window [" ++ wn ++ "] unhidden.'")

        -- UNUSED. XMonad.Actions.CopyWindow, but with notifications.
        "copyAll"     -> spawn ("notify-send " ++ copyNotifyArgs ++ " 'Copied ["++ wn ++ "] to all workspaces.'")
        "copiesKill"  -> spawn ("notify-send " ++ copyNotifyArgs ++ " 'Killed all copies of [" ++ wn ++ "].'")

        -- XMonad.Util.StickyWindows, but with notifications.
        "sticky"   -> spawn ("notify-send " ++ stickyNotifyArgs ++ " 'Made window [" ++ wn ++ "] sticky.'")
        "unsticky" -> spawn ("notify-send " ++ stickyNotifyArgs ++ " 'Unstuck window [" ++ wn ++ "].'")

screenCorners :: [(ScreenCorner, X ())]
screenCorners = [
                (SCUpperRight, spawn ("~/.config/xmonad/scripts/wallpaper_setter/setWallpaper " ++ wallpaperDir ++ " right"))
                , (SCUpperLeft,  spawn ("~/.config/xmonad/scripts/wallpaper_setter/setWallpaper " ++ wallpaperDir ++ " left"))
                ]

changeBrightness :: Integer -> X()
changeBrightness value
               | value > 0 = spawn ("brillo -u 150000 -A " ++ show (value))
               | value < 0 = spawn ("brillo -u 150000 -U " ++ show (abs value))
                    
notifyBrightness :: X()
notifyBrightness = spawn ("~/Scripts/brightness_notifs.sh")

notifyVolume :: X()
notifyVolume = spawn ("~/Scripts/volume_notifs.sh") 

getWindowName :: X String
getWindowName = do
    wn <- runProcessWithInput "xdotool" ["getactivewindow", "getwindowname"] ""

    let rstrip = reverse . dropWhile isSpace . reverse
    let parseSlash = map (\x -> if x == '\'' then '`' else x) -- an apostrophe breaks the command inside 'spawn', so replace with a backtick
    let windowName = parseSlash . rstrip . shorten 40 $ wn

    return windowName
