local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local config = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local find_cmd = { "find", ".", "-maxdepth", "15", "-type", "d" }
if vim.fn.executable("fd") == 1 then
	find_cmd = { "fd", "--hidden", "--type", "d", "--maxdepth", "15" }
end

local M = {}
M.cd = function(opts)
	opts = opts or {}
	print(vim.inspect(opts))

	pickers.new(opts, {
		prompt_title = "Change directory",
		finder = finders.new_oneshot_job(find_cmd, opts),
		sorter = config.file_sorter(opts),
		attach_mappings = function(bufnr, map)
			actions.select_default:replace(function()
				actions.close(bufnr)
				local selection = action_state.get_selected_entry()
				local dir = selection[1]

				vim.cmd(string.format("cd %s", dir))
			end)

			return true
		end,
	}):find()
end

return M
