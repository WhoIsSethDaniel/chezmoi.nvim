local function chezmoi(...)
    local args = ''
    for _, a in ipairs{...} do
        args = args .. ' ' .. a
    end
    local f = io.popen(string.format("chezmoi %s", args))
    local content = f:lines('*a')()
    f:close()
    return content
end

local M = {}

function M.is_managed()
    local out = chezmoi(string.format("source-path %s", vim.fn.expand('%')))
    if string.find(out, 'does not exist') == nil then
        return true
    else
        return false
    end
end

return M

