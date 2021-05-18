local api = vim.api
local chezmoi_bin = ''

local function chezmoi(cmd)
    local f = io.popen(string.format("%s %s", chezmoi_bin, cmd))
    local content = f:lines('*a')()
    f:close()
    return content
end

local function chezmoi_add(file)
    return chezmoi(string.format("add %s", vim.fn.shellescape(vim.fn.expand(file))))
end

local function chezmoi_forget(file)
    return chezmoi(string.format("forget %s", vim.fn.shellescape(vim.fn.expand(file))))
end

local function chezmoi_source_path(file)
    return chezmoi(string.format("source-path %s", vim.fn.shellescape(vim.fn.expand(file))))
end

local Chezmoi = {
    conf = {}
}

local defaultConf = {
    exec = vim.g.chezmoi_exec or Chezmoi.conf.exec or 'chezmoi'
}

Chezmoi.conf = defaultConf

function Chezmoi.setup(config)
    if config == nil then
        return
    end
    for k, v in pairs(config) do
        Chezmoi.conf[k] = v
    end
    chezmoi_bin = vim.fn.exepath(Chezmoi.conf.exec)
    if chezmoi_bin == '' then
        api.nvim_err_writeln(string.format("Cannot find an executable named '%s'", Chezmoi.conf.exec))
    end
end

function Chezmoi.is_managed(file)
    if file == nil or file == '' then
        return
    end
    local out = chezmoi_source_path(file)
    if string.find(out, 'does not exist') == nil and string.find(out, 'outside target directory') == nil then
        return true
    else
        return false
    end
end

function Chezmoi.status()
    if Chezmoi.is_managed('%') then
        return '[CM]'
    end
end

function Chezmoi.save(file)
    if Chezmoi.is_managed(file) then
        chezmoi_add(file)
    end
end

function Chezmoi.add(file)
    chezmoi_add(file)
end

function Chezmoi.remove(file)
    if Chezmoi.is_managed(file) then
        chezmoi_forget(file)
    end
end

return Chezmoi
