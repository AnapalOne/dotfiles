-- read file and print contents of file
function conky_readPrintFile(file)
    local f = io.open(file, "r")
    
    -- if file doesn't exist, return 0
    if not f then return 0 end

    local content = f:read("*a")
    f:close()

    return content
end

function conky_runTodo()
    os.execute("alacritty -t 'todo' -e todo -e")
end