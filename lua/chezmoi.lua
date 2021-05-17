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

function M.is_managed(file)
    local file = vim.fn.expand(file)
    if file == nil or file == '' then
        return
    end
    local out = chezmoi(string.format("source-path %s", file))
    if string.find(out, 'does not exist') == nil then
        return true
    else
        return false
    end
end

function M.chezmoi_status()
    if M.is_managed('%') then
        return '[CM]'
    end
end

function M.save(file)
    local file = vim.fn.expand(file)
    if not M.is_managed(vim.fn.expand(file)) then
        return
    end
    chezmoi(string.format("add %s", file))
end

return M
