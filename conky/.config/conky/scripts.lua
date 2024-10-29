-- read file and print contents of file
function readPrintFile(file)
    local f = io.open(file, "rb")
    
    -- if file doesn't exist, return nil
    if not f then return nil end

    local content = f:read("*a")
    f:close()

    return content
end

-- get song title from a music source
function getSongTitle()
    local command = io.popen("playerctl metadata --player spotify --format '{{ artist }} - {{ title }}'", "r")
    local title = command:read("*l")
    command:close()

    if title == "No players found" or not title then
        title = "there is no player, oops"
    end 

    local format = "♪ " .. title .. " ♪"
    return format:gsub("\n", "")
end

-- get song lyrics from a music source
function getSongLyrics()
    local lyrics = readPrintFile("/tmp/sptlrx_lyrics") or ""
    lyrics = lyrics:match("^%s*(.-)%s*$")
    
    if lyrics == "" or lyrics == nil then
        lyrics = "lyrics not available"
    end

    return lyrics:gsub("\n", "")
end

function conky_displaySongTitle()
    return getSongTitle()
end

function conky_displaySongLyrics()
    return getSongLyrics()
end