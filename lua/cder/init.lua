local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local config = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

M.find_cmd = function(opts)
	local fd_installed = vim.fn.executable("fd")

	local cmd = { "find", ".", "-maxdepth", "15", "-type", "d" }
	if fd_installed == 1 then
		cmd = { "fd", "--hidden", "--type", "d", "--maxdepth", "15" }
	end

	local excludes = opts.exclude
	if not (excludes == nil) then
		for k, v in pairs(excludes) do
			if fd_installed == 1 then
				cmd = vim.list_extend(cmd, { "-E", v })
			else
				cmd = vim.list_extend(cmd, { "-not", "-iname", v })
			end
		end
	end

	return cmd
end


M.cd = function(opts)
	opts = opts or {}

	pickers.new(opts, {
		prompt_title = "Change directory",
		finder = finders.new_oneshot_job(M.find_cmd(opts), opts),
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

M.cd({exclude= {"Library"}})

return M
