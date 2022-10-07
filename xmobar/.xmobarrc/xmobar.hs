Config { 

   -- // appearance
     font =         "xft:Bitstream Vera Sans Mono:size=7:bold:antialias=true:hinting=true, Symbols Nerd Font:size=10"
   , bgColor =      "black"
   , fgColor =      "white"
   , borderColor =  "#ffffff"


   -- // position
   -- options: Top, TopP, TopW, TopSize, Bottom, BottomP, BottomW, BottomSize or Static
   --          examples:
   --              Static { xpos = 16 , ypos = 16, width = 1888, height = 25 }
   --              BottomW C 75
   --              BottomP 120 0
   , position = Static { xpos = 16 , ypos = 16, width = 1888, height = 25 }


   -- options: TopB, TopBM, BottomB, BottomBM, FullB, FullBM or NoBorder 
   --     TopB, BottomB, FullB take no arguments, and request drawing a border at the top, bottom or around xmobar's window, respectively.
   --     TopBM, BottomBM, FullBM take an integer argument, which is the margin, in pixels, between the border of the window and the drawn border.
   , border = NoBorder


   -- // layout
   , sepChar =  "$"   -- delineator between plugin names and straight text
   , alignSep = "}{"  -- separator between left-right alignment eff214
   , template = "  $default:Master$  | $UnsafeStdinReader$}{<fc=#909090>$cpu$</fc> / <fc=#818181>$coretemp$</fc> | <fc=#909090>$memory$</fc> | <fc=#909090>$dynnetwork$</fc> | $disku$ [ $uptime$ | $date$ ]  "


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
        [ Run Uptime	 [ "--template", "<fc=#ABABAB><hours>h <minutes>m <seconds>s</fc>" ] 10

            -- shows pp config in xmonad.hs
        , Run UnsafeStdinReader

            -- network activity monitor (dynamic interface resolution)
        , Run DynNetwork     [ "--template" , "<fc=#0192ff>\xf093</fc> <tx>kB/s / <fc=#0192ff>\xf019</fc> <rx>kB/s"
                             , "--Low"      , "5000000"     -- units: B/s
                             , "--High"     , "20000000"    -- units: B/s
                             , "--low"      , "#1bc800"
                             , "--normal"   , "darkorange" --darkorange
                             , "--high"     , "darkred" --darkred
                             ] 20

            -- cpu activity monitor
        , Run Cpu            [ "--template" , "<fc=#3cfb05>\xf108</fc> <total>%"
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
        -- , Run Com "sh" [ "-c", "nvidia-smi -a | grep Gpu | sed 's/        Gpu                               : //g' | sed 's/ //' | sed 's/%//'" ] "gpu" 50

            -- memory usage monitor
        , Run Memory         [ "--template" ,"<fc=#f44336>\xf2db</fc> <usedratio>%"
                             , "--Low"      , "60"        -- units: %
                             , "--High"     , "90"        -- units: %
                             , "--low"      , "#1bc800"
                             , "--normal"   , "darkorange"
                             , "--high"     , "darkred"
                             ] 60

            -- disk size monitor
        , Run DiskU [("/", "<fc=#f7a60e>\xf7c9</fc> <fc=#9f9f9f><used>B / <size>B</fc>")] 
                    [] 100

            -- battery monitor (<timeleft> in discharging status for battery time left)
        -- , Run Battery        [ "--template" , "<leftbar> <acstatus>"
        --                      , "--Low"      , "15"        -- units: %
        --                      , "--High"     , "40"        -- units: %
        --                      , "--low"      , "darkred"
        --                      , "--normal"   , "darkorange"
        --                      , "--high"     , "#1bc800"
        --                      , "-f", "\xf244\xf243\xf243\xf243\xf242\xf242\xf241\xf241\xf241\xf240" -- horizontal
        --                      -- , "-f", "\xf579\xf57a\xf57b\xf57c\xf57d\xf57e\xf57f\xf580\xf581\xf578" -- vertical
        --                      , "-W", "0"

        --                      , "--"
        --                                -- discharging status
        --                                , "-o" , "<left>%"
        --                                -- AC "on" status
        --                                , "-O" , "<fc=#dAA520>Charging..</fc>"
        --                                -- charged status
        --                                , "-i" , "Charged!"    
        --                      ] 50

            -- time and date indicator 
        --   (%F = y-m-d date, %a = day of week, %T = 24-hour format/%r = 12-hour format)
        , Run Date           "<fc=#ABABAB>%F (%a) %r</fc>" "date" 10

            -- keyboard layout indicator
        -- , Run Kbd            [ ("us(dvorak)" , "<fc=#00008B>DV</fc>")
        --                     , ("us"         , "<fc=#4682B4>KeyB: </fc", "<fc=#8B0000>US</fc>")
        --                     ]

            -- volume (alias %default:Master%)
        -- , Run Com "/home/anapal/Scripts/volume.sh" [] "volume" 10
        , Run Volume "default" "Master" [ "-t", "<fc=#a0a0a0><volumebar><status></fc>"
                                        , "-f", "\xfa7e\xfa7e\xfa7e\xfa7f\xfa7f\xfa7f\xfa7f\xfa7d\xfa7d\xfa7d"
                                        , "-W", "0"

                                        , "--"
                                              , "-O", ""
                                              , "-o", "<fc=#a0a0a0>\xf655</fc>"
                                        ] 10

            -- weather monitor (add %RJTT% beteen uptime and date)
        -- , Run Weather "RJTT" [ "--template", "<skyCondition> | <fc=#4682B4><tempC></fc>°C | <fc=#4682B4><rh></fc>% | <fc=#4682B4><pressure></fc>hPa"
        --                     ] 36000
        ]
   }
