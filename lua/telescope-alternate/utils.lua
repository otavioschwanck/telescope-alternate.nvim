local M = {}

function M.isdir(path)
  return vim.fn.isdirectory(path)
end

function M.path_difference(old, new)
  ---@diagnostic disable-next-line: redefined-local
  local old = old:gsub("%*%*/%*", ""):gsub("%*", "")

  local splittedOld = M.split(old, "/")
  local splittedNew = M.split(new, "/")

  local words = {}
  local jumps = 0

  for i = 1, #splittedNew, 1 do
    if not (splittedOld[i] == splittedNew[i + jumps]) then
      local completed = false

      while not completed do
        if not (splittedOld[i] == splittedNew[i + jumps]) and splittedNew[i + jumps] ~= nil then
          local newString = splittedNew[i + jumps]:gsub(splittedOld[i] or '', '')
          table.insert(words, newString)
          jumps = jumps + 1
        else
          completed = true
        end
      end
    end
  end

  return words
end

function M.capture(path)
  local s = vim.fn.system("find " .. path)

  if string.match(s, 'no matches found:') then
    return {}
  end

  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '//', '/')
  s = string.gsub(s, '[\n\r]+', '||')

  vim.cmd("redraw")

  return M.split(s, '||')
end


function M.split(s, delimiter)
  local result = {};

  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match);
  end

  return result;
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

  -- Only target literal parts of the path (i.e exclude lua patterns)
  -- This assumes that in the literal part of the path the `-` will be preceeded
  -- by only alphanumeric characters. It also assumes that lua patters will only 
  -- ever have an alpha-numeric char preceeding the `-` special character.
  s = string.gsub(s, "(%x)%-", "%1%%-")

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
