local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local config = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}
M.cd = function(opts)
	opts = opts or {}
	pickers.new(opts, {
		prompt_title = "Change directory",
		finder = finders.new_oneshot_job({ "find", ".", "-maxdepth", "10", "-type", "d" }, opts),
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
