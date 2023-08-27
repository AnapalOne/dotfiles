---------------------------------------------------------
--            xmobar config by Anapal                  --
--     My personal config for my (or your) needs.      --
--                                                     --
--      > https://github.com/AnapalOne/dotfiles        --
---------------------------------------------------------

Config { 

   -- // appearance
     font =            "Bitstream Vera Sans Mono, Source Han Sans JP Normal 8, Bold 8"
   , additionalFonts = ["Symbols Nerd Font 10"]
   , bgColor =         "black"
   , fgColor =         "white"
   , borderColor =     "#ffffff"


   -- // position
   -- options: Top, TopP, TopW, TopSize, Bottom, BottomP, BottomW, BottomSize or Static
   --          examples:
   --              Static { xpos = 16 , ypos = 16, width = 1888, height = 25 }
   --              BottomW C 75
   --              BottomP 120 0
   , position = Static { xpos = 12 , ypos = 16, width = 1892, height = 25 }


   -- options: TopB, TopBM, BottomB, BottomBM, FullB, FullBM or NoBorder 
   --     TopB, BottomB, FullB take no arguments, and request drawing a border at the top, bottom or around xmobar's window, respectively.
   --     TopBM, BottomBM, FullBM take an integer argument, which is the margin, in pixels, between the border of the window and the drawn border.
   , border = NoBorder


   -- // layout
   , sepChar =  "$"   -- delineator between plugin names and straight text
   , alignSep = "}{"  -- separator between left-right alignment eff214
   , template = "   $default:Master$ <fc=#909090>|</fc> $UnsafeStdinReader$ } $mpris2$ { <fc=#909090> $cpu$ / $coretemp$ | $gpu$ | $memory$ | $dynnetwork$ | $disku$</fc> [ <fc=#ababab>$uptime$ | $date$</fc> ] $_XMONAD_TRAYPAD$"

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
                             , "--normal"   , "darkorange" --darkorange
                             , "--high"     , "darkred" --darkred
                             ] 20

          -- mpris2 activity monitor for spotify
        , Run Mpris2 "spotify" [ "--template", "<fc=#909090><fn=1><fc=darkgreen>\xf1bc</fc></fn> <artist> - <title></fc>"
                               , "--nastring", ""
                               , "--maxwidth", "30"
                               ] 10

            -- cpu activity monitor
        , Run Cpu            [ "--template" , "<fn=1><fc=#3cfb05>\xf108</fc></fn> <total>%"
                             , "--Low"      , "50"         -- units: %
                             , "--High"     , "85"         -- units: %
                             , "--low"      , "#1bc800"
                             , "--normal"   , "darkorange"
                             , "--high"     , "darkred"
                             ] 50

            -- cpu core temperature monitor
        , Run Com "sh" ["-c", "sensors | grep Tctl | sed 's/Tctl:         +//' | sed 's/[ \t]*$//'" ] "coretemp" 50
        -- , Run CoreTemp       [ "--template" , "<core0>°C"
        --                      , "--Low"      , "60"        -- units: °C
        --                      , "--High"     , "80"        -- units: °C
        --                      , "--low"      , "#1bc800"
        --                      , "--normal"   , "darkorange"
        --                      , "--high"     , "darkred"
        --                      ] 50
                          
            -- gpu activity monitor (alias gpu) (<fc=#a9a9a9>$gpu$</fc><fc=#909090>%</fc>)
        , Run Com "/home/anapal/.config/xmonad/scripts/gpu_monitor.sh" [] "gpu" 50

            -- memory usage monitor
        , Run Memory         [ "--template" ,"<fn=1><fc=#f44336>\xf2db</fc></fn> <usedratio>%"
                             , "--Low"      , "60"        -- units: %
                             , "--High"     , "90"        -- units: %
                             , "--low"      , "#1bc800"
                             , "--normal"   , "darkorange"
                             , "--high"     , "darkred"
                             ] 60

            -- disk size monitor
        , Run DiskU [("/", "<fn=1><fc=#f7a60e>\xf02ca</fc></fn> <fc=#9f9f9f><used>B / <size>B</fc>")] 
                    [] 100

        -- , Run DiskIO [("sdb6", "<total>")] 
        --              [ "--Low"      , "2000000"
        --              , "--High"     , "3000000"
        --              , "--normal"   , "darkorange"
        --              , "--high"     , "darkred"
        --              ] 100

            -- time and date indicator 
        --   (%F = y-m-d date, %a = day of week, %T = 24-hour format/%r = 12-hour format)
        , Run Date           "<fc=#ABABAB>%F (%a) %r</fc>" "date" 10

            -- volume (alias %default:Master%)
        -- , Run Com "/home/anapal/Scripts/volume.sh" [] "volume" 10
        , Run Volume "default" "Master" [ "-t", "<fc=#a0a0a0><fn=1><volumebar></fn> <volume>% <fn=1><status></fn></fc>"
                                        , "-f", "\xf057f\xf057f\xf057f\xf0580\xf0580\xf0580\xf0580\xf057e\xf057e\xf057e"
                                        , "-W", "0"

                                        , "--"
                                              , "-O", ""
                                              , "-o", "<fc=#a0a0a0>\xea76</fc>"
                                        ] 10

            -- checks for system and application updates (alias checkupdates) 
        , Run Com "/home/anapal/.config/xmonad/scripts/checkupdate.sh" [] "checkupdates" 3000
        ]
   }
