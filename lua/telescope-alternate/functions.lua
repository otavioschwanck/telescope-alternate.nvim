local M = {}

-- function get on rgroli/other.nvim
M.camel_to_kebap = function(inputString)
	local pathParts = {}

	inputString:gsub("%w+[^/]", function(str)
		table.insert(pathParts, str)
	end)

	for i, part in pairs(pathParts) do
		local camelParts = {}
		part:gsub("%u%l+", function(str)
			table.insert(camelParts, str:lower())
		end)
		pathParts[i] = table.concat(camelParts, "-")
	end

	return table.concat(pathParts, "/")
end

-- function get on rgroli/other.nvim
M.kebap_to_camel = function(inputString)
	local pathParts = {}

	inputString:gsub("[%w-_]+[^/]", function(str)
		table.insert(pathParts, str)
	end)

	for i, part in pairs(pathParts) do
		local tmp = ""
		for key in part:gmatch("[^-]+") do
			tmp = tmp .. key:sub(1, 1):upper() .. key:sub(2)
		end
		pathParts[i] = tmp
	end

	return table.concat(pathParts, "/")
end

M.pluralize = function(inputString)
  local lastCharacter = inputString:sub(-1, -1)

  if lastCharacter == "y" then
    local stringWithoutY = inputString:sub(1, -2)

    return stringWithoutY .. "ies"
  elseif lastCharacter == "s" then
    return inputString
  else
    return inputString .. "s"
  end
end

M.singularize = function(inputString)
  local lastCharacter = inputString:sub(-1, -1)

  local lastThreeCharacters = ""

  if #inputString >= 3 then
    lastThreeCharacters = inputString:sub(-3, -1)
  end

  if lastThreeCharacters == "ies" then
    local stringWithoutIes = inputString:sub(1, -4)

    return stringWithoutIes .. "y"
  elseif lastCharacter == "s" then
    return inputString:sub(1, -2)
  else
    return inputString
  end
end

return M
