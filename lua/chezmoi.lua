local api = vim.api
local chezmoi_bin = ''

local function chezmoi(cmd)
  local f = io.popen(string.format("%s %s 2>&1", chezmoi_bin, cmd))
  local content = f:lines('*l')()
  f:close()
  return content
end

local function chezmoi_add(file, options)
  return chezmoi(string.format("add %s %s", options or '', vim.fn.shellescape(vim.fn.expand(file))))
end

local function chezmoi_apply(file)
  return chezmoi(string.format("apply %s", vim.fn.shellescape(vim.fn.expand(file))))
end

local function chezmoi_forget(file, options)
  return chezmoi(string.format("forget %s %s", options or '', vim.fn.shellescape(vim.fn.expand(file))))
end

local function chezmoi_version()
  return chezmoi('--version')
end

local function chezmoi_source_path(file)
  if file == nil then
    return chezmoi("source-path")
  else
    return chezmoi(string.format("source-path %s", vim.fn.shellescape(vim.fn.expand(file))))
  end
end

local Chezmoi = { conf = {} }

local defaultConf = {
  exec = vim.g.chezmoi_exec or Chezmoi.conf.exec or 'chezmoi',
  auto_add = vim.g.chezmoi_auto_add or Chezmoi.conf.auto_add or true,
  add_options = vim.g.chezmoi_add_options or Chezmoi.conf.add_options or '--empty'
}

Chezmoi.conf = defaultConf

function Chezmoi.setup_add_autocmd()
  vim.cmd [[
        augroup chezmoi_auto_add
            autocmd! 
            autocmd BufWritePost * lua require'chezmoi'.save('%')
        augroup END
    ]]
end

function Chezmoi.setup(config)
  if config == nil then
    return
  end
  for k, v in pairs(config) do
    Chezmoi.conf[k] = v
  end
  chezmoi_bin = vim.fn.exepath(Chezmoi.conf.exec)
  if chezmoi_bin == '' then
    api.nvim_echo({ string.format("chezmoi.nvim: cannot find an executable named '%s'", Chezmoi.conf.exec), 'ErrorMsg' }, true, {})
    return
  end

  if Chezmoi.conf.auto_add == true then
    Chezmoi.setup_add_autocmd()
  end

  local v = Chezmoi.version()
  if v.major ~= 2 then
    api.nvim_echo({
      {
        string.format('chezmoi.nvim: chezmoi major version is not 2. chezmoi.nvim probably won\'t work. exec = %s; version = %d', chezmoi_bin, v.major),
        'ErrorMsg'
      }
    }, true, {})
    return
  end
end

function Chezmoi.is_managed(file)
  file = vim.fn.expand(file)
  if file == nil or file == '' then
    return
  end
  local out = chezmoi_source_path(file)
  if string.find(out, 'not in') == nil and string.find(out, 'does not exist') == nil and string.find(out, 'outside target directory') == nil then
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

function Chezmoi.version()
  local vstr = chezmoi_version()
  local maj, min, patch = string.match(vstr, '^chezmoi version v(%d+)%.(%d+)%.(%d+)')
  if maj == nil then
    maj = 0
    min = 0
    patch = 0
  else
    maj = tonumber(maj)
    min = tonumber(min)
    patch = tonumber(patch)
  end
  return { major = maj, minor = min, patch = patch }
end

function Chezmoi.cmdline_add(file, options)
  if options == '' or options == nil then
    Chezmoi.add(file)
  else
    Chezmoi.add(file, options)
  end
end

function Chezmoi.cmdline_forget(file)
  if Chezmoi.is_managed(file) then
    Chezmoi.forget(file)
  end
end

function Chezmoi.add(file, options)
  chezmoi_add(file, options or Chezmoi.conf.add_options)
end

function Chezmoi.forget(file)
  if Chezmoi.is_managed(file) then
    chezmoi_forget(file, '--force')
  end
end

function Chezmoi.save(file)
  if Chezmoi.is_managed(file) then
    chezmoi_add(file)
  end
end

return Chezmoi
