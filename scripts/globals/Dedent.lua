---Dedents input for use in dialogue
---@param str string A multiline string with indentation
---@return string
function Dedent(str)
    local lines = Utils.split(str, "\n", false)
    local shortest_indentation = math.huge
    for _, str in ipairs(lines) do
        if str == "" then goto continue end
        if str == string.rep(" ", #str) then goto continue end
        local this_indent = 1
        for i=1, #str do
            local char = str:sub(i,i)
            if char ~= " " then break end
            this_indent = this_indent + 1
        end
        shortest_indentation = math.min(shortest_indentation, this_indent)
        ::continue::
    end
    for i=1,#lines do
        lines[i] = lines[i]:sub(shortest_indentation)
    end
    return table.concat(lines, "\n")
end
return Dedent