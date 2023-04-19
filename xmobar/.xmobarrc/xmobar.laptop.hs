---------------------------------------------------------
--            xmobar Config by Anapal                  --
--     My personal config for my (or your) needs.      --
--                                                     --
--      > https://github.com/AnapalOne/dotfiles        --
---------------------------------------------------------

Config { 

   -- // appearance
     font =         "Bitstream Vera Sans Mono, Symbols Nerd Font Mono 11, Source Han Sans JP Normal 9, WenQuanYi Zen Hei Mono 9, Bold 9"
   , additionalFonts = ["Symbols Nerd Font Mono 11"]
   , bgColor =      "black"
   , fgColor =      "white"
   , borderColor =  "#ffffff"


   -- // position
   -- options: Top, TopP, TopW, TopSize, Bottom, BottomP, BottomW, BottomSize or Static
   --          examples:
   --              Static { xpos = 14 , ypos = 10, width = 1330, height = 20 }
   --              BottomW C 75
   --              BottomP 120 0
   -- , position = Static { xpos = 12, ypos = 12, width = 1341, height = 22 } -- for 1366x768 screens
   , position = Static { xpos = 12, ypos = 16, width = 1892, height = 28 } -- for 1980x1080 screens


   -- // border
   -- options: TopB, TopBM, BottomB, BottomBM, FullB, FullBM or NoBorder 
   --     TopB, BottomB, FullB take no arguments, and request drawing a border at the top, bottom or around xmobar's window, respectively.
   --     TopBM, BottomBM, FullBM take an integer argument, which is the margin, in pixels, between the border of the window and the drawn border.
   , border = NoBorder


   -- // layout
   , sepChar =  "$"   -- delineator between plugin names and straight text
   , alignSep = "}{"  -- separator between left-right alignment
   , template = "  $battery$  $default:Master$ | $UnsafeStdinReader$ }{ <fc=#909090>$cpu$ / $coretemp$ | $memory$ | $dynnetwork$ | $disku$</fc> [ <fc=#ABABAB>$uptime$ | $date$</fc> ]$_XMONAD_TRAYPAD$"


   -- // general behavior
   , lowerOnStart =     True    -- send to bottom of window stack on start
   , hideOnStart =      False   -- start with window unmapped (hidden)
   , allDesktops =      True    -- show on all desktops
   , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
   , pickBroadest =     False   -- choose widest display (multi-monitor)
   , persistent =       True    -- enable/disable hiding (True = disabled)


   -- // layout template
   , commands = 
	       -- uptime monitor
	      [ Run Uptime	 [ "--template", "<hours>h <minutes>m <seconds>s" ] 10

          -- shows pp config in xmonad.hs
        , Run UnsafeStdinReader

        , Run XPropertyLog "_XMONAD_TRAYPAD"

          -- network activity monitor (dynamic interface resolution)
        , Run DynNetwork     [ "--template" , "<fn=1><fc=#0192ff>\xf093</fc></fn> <tx>kB/s / <fn=1><fc=#0192ff>\xf019</fc></fn> <rx>kB/s"
                             , "--Low"      , "5000000"     -- units: B/s
                             , "--High"     , "20000000"    -- units: B/s
                             , "--low"      , "#1bc800"
                             , "--normal"   , "darkorange" 
                             , "--high"     , "darkred" 
                             ] 20

          -- mpris2 activity monitor for spotify
        , Run Mpris2 "spotify" [ "--template", "<fc=darkgreen>\xf1bc</fc> <artist> - <title> |"
                               , "--nastring", ""
                               , "--maxwidth", "35"
                               ] 50

          -- cpu activity monitor
        , Run Cpu            [ "--template" , "<fn=1><fc=#3cfb05>\xf108</fc></fn> <total>%"
                             , "--Low"      , "50"         -- units: %
                             , "--High"     , "85"         -- units: %
                             , "--low"      , "#1bc800"
                             , "--normal"   , "darkorange"
                             , "--high"     , "darkred"
                             ] 50

          -- cpu core temperature monitor
        , Run CoreTemp       [ "--template" , "<core0>°C"
        --                      -- , "--Low"      , "60"        -- units: °C
        --                      -- , "--High"     , "80"        -- units: °C
        --                      -- , "--low"      , "#1bc800"
        --                      -- , "--normal"   , "darkorange"
        --                      -- , "--high"     , "darkred"
                            ] 50

        -- , Run Com "sh" ["-c", "sensors | grep 'Package id 0' | sed 's/Package id 0:  +//' | sed 's/C.*$/C/'" ] "coretemp" 50
                          
          -- memory usage monitor
        , Run Memory         [ "--template" ,"<fn=1><fc=#f44336>\xf2db</fc></fn> <usedratio>%"
                             , "--Low"      , "60"        -- units: %
                             , "--High"     , "90"        -- units: %
                             , "--low"      , "#1bc800"
                             , "--normal"   , "darkorange"
                             , "--high"     , "darkred"
                             ] 50

          -- disk size monitor
        , Run DiskU [("/", "<fn=1><fc=#f7a60e>\xf7c9</fc></fn> <fc=#9f9f9f><used>B / <size>B</fc>")] 
                    [] 50

          -- battery monitor (<timeleft> in discharging status for battery time left)
        , Run Battery        [ "--template" , "<fn=1><leftbar></fn> <acstatus>"
                             , "--Low"      , "15"        -- units: %
                             , "--High"     , "40"        -- units: %
                             , "--low"      , "darkred"
                             , "--normal"   , "darkorange"
                             , "--high"     , "#1bc800"
                             , "-f", "\xf244\xf243\xf243\xf243\xf242\xf242\xf241\xf241\xf241\xf240" -- horizontal
                             -- , "-f", "\xf579\xf57a\xf57b\xf57c\xf57d\xf57e\xf57f\xf580\xf581\xf578" -- vertical
                             , "-W", "0"

                             , "--"
                                       -- ac "off" status
                                       , "-o" , "<left>%"
                                       -- ac "on" status
                                       , "-O" , "<left>% \xe315"
                                       -- ac "idle" status
                                       , "-i" , "Idle.."    
                             ] 25

          -- time and date indicator 
        --   (%F = y-m-d date, %a = day of week, %T = 24-hour format/%r = 12-hour format)
        , Run Date           "%F (%a) %r" "date" 10

        -- volume (alias %default:Master%)
        -- , Run Com "/home/anapal/Scripts/volume.sh" [] "volume" 10
        , Run Volume "default" "Master" [ "-t", "<fc=#a0a0a0><fn=1><volumebar></fn> <volume>% <fn=1><status></fn></fc>"
                                        , "-f", "\xf057f\xf057f\xf057f\xf0580\xf0580\xf0580\xf0580\xf057e\xf057e\xf057e"
                                        , "-W", "0"

                                        , "--"
                                              , "-O", ""
                                              , "-o", "<fc=#a0a0a0>\xf0156</fc>"
                                        ] 5

          -- keyboard layout indicator
        -- , Run Kbd            [ ("us(dvorak)" , "<fc=#00008B>DV</fc>")
        --                     , ("us"         , "<fc=#4682B4>KeyB: </fc", "<fc=#8B0000>US</fc>")
        --                     ]

        -- weather monitor (add %RJTT% beteen uptime and date)
        -- , Run Weather "RJTT" [ "--template", "<skyCondition> | <fc=#4682B4><tempC></fc>°C | <fc=#4682B4><rh></fc>% | <fc=#4682B4><pressure></fc>hPa"
        --                     ] 36000
        ]
   }
