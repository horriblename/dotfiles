M = {}
local function parseTermFile(name)
	-- 'term://{cwd}//{pid}:{cmd}'
	local seg = vim.split(name, '//')
	if seg[1] ~= 'term:' then
		return nil, nil
	end

	local pidcmd = vim.fn.join(vim.list_slice(seg, 5, #seg), '')
	local npid = pidcmd:match(':')
	if not npid then
		print(npid)
		return nil, nil, nil
	end

	return seg[3], pidcmd:sub(1, npid - 1), pidcmd:sub(npid + 1)
end
M.parseTermFile = parseTermFile

local function termFileTitle(cwd, pid, cmd)
	return 'term://' .. cwd .. '//' .. pid .. ':' .. cmd
end

M.SetTermTitle = function(cwd, pid, cmd)
	local d, p, c = parseTermFile(vim.fn.bufname(''))
	if p ~= pid or not d or not p or not c then return 'failed' end

	cwd = cwd or d
	cmd = cmd or c

	local title = termFileTitle(cwd, pid, cmd)
	vim.cmd('keepalt file ' .. title)
	return 'succ'
end

return M
