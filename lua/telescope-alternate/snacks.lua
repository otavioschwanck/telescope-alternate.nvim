local Snacks = require("snacks")

local M = {}
local function removeCommonPrefix(nestedStrings)
    if #nestedStrings == 0 then return nestedStrings end
    if #nestedStrings == 1 then return nestedStrings end

    -- Extract paths for processing
    local paths = {}
    for i, item in ipairs(nestedStrings) do
        paths[i] = item.path
    end

    -- Find the shortest string length
    local minLen = math.huge
    for _, str in ipairs(paths) do
        minLen = math.min(minLen, #str)
    end

    -- Find common prefix length
    local prefixLen = 0
    for i = 1, minLen do
        local char = paths[1]:sub(i, i)
        local isCommon = true
        for _, str in ipairs(paths) do
            if str:sub(i, i) ~= char then
                isCommon = false
                break
            end
        end
        if isCommon then
            prefixLen = i
        else
            break
        end
    end

    -- Create new list with common prefix removed
    local result = {}
    for i, item in ipairs(nestedStrings) do
        local newItem = {
            short_path = item.path:sub(prefixLen + 1),
            path = item.path,
            label = item.label,
            order = item
                .order
        }
        table.insert(result, newItem)
    end

    return result
end

M.alternate = function()
    local raw_files = require "telescope-alternate.finders".find_alternatve_files()
    local files = removeCommonPrefix(raw_files)

    Snacks.picker({
        finder = function()
            local items = {}
            for i, item in ipairs(files) do
                table.insert(items, {
                    idx = i,
                    order = item.order,
                    file = item.path,
                    text = item.short_path,
                    label = item.label,
                })
            end
            return items
        end,
        layout = {
            layout = {
                box = "horizontal",
                width = 0.5,
                height = 0.5,
                {
                    box = "vertical",
                    border = "rounded",
                    title = "Project files",
                    { win = "input", height = 1,     border = "bottom" },
                    { win = "list",  border = "none" },
                },
            },
        },

        -- win = {
        --     -- input window
        --     input = {
        --         keys = {
        --
        --             ["<c-\\>"] = { "flash", mode = { "n", "i" } },
        --             ["<c-s>"] = { "split", mode = { "n", "i" } },
        --             ["<c-v>"] = { "vsplit", mode = { "n", "i" } },
        --         }
        --     }
        -- },
        --
        -- list = {
        --     -- input window
        --     input = {
        --         keys = {
        --
        --             ["<c-\\>"] = { "flash", mode = { "n", "i" } },
        --             ["<c-s>"] = { "split", mode = { "n", "i" } },
        --             ["<c-v>"] = { "vsplit", mode = { "n", "i" } },
        --         }
        --     }
        -- },

        format = function(item, _)
            local file = item.file
            local ret = {}
            local a = Snacks.picker.util.align
            local icon, icon_hl = Snacks.util.icon(file.ft, "directory")
            ret[#ret + 1] = { a(item.label, 20) }
            ret[#ret + 1] = { a(icon, 3), icon_hl }
            ret[#ret + 1] = { " " }
            ret[#ret + 1] = { a(item.text, 20) }

            return ret
        end,
        -- confirm = function(picker, item)
        --     picker:close()
        --     vim.cmd.edit(item.file)
        --     -- Snacks.picker.pick("files", {
        --     --     files = { item.file },
        --     -- })
        -- end,
    })
end

-- M.alternate()
return M
