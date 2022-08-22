local M = {}

function M.isdir(path)
  return vim.fn.isdirectory(path)
end

function M.isfile(path)
  return vim.fn.filereadable(path)
end

function M.files_in_path(path)
  return vim.fn.split(vim.fn.globpath(path, '*'), '\n')
end

function M.current_file_name()
  return vim.fn.fnamemodify(vim.fn.expand('%'), ":~:.")
end

function M.normalize_path(text)
  local s = text

  s = string.gsub(s, '%-', '%%-')

  return s
end

function M.escape(s)
  s = string.gsub(s, "([&=+%c])", function (c)
    return string.format("%%%02X", string.byte(c))
  end)
  s = string.gsub(s, " ", "+")
  return s
end

return M
