M = {}

-- note: nested emphasis NOT allowed
--   *emph *with emph* in it*

local config = {
	bold = '**',
	italic = '*',
}

---------------------------------
-- Collapse Lists
---------------------------------
vim.cmd [[
function! MarkdownBetterFold()
	let header = MarkdownFold()
	if header == '='
		return 6 + indent('.')
	endif
	return header
endfu
]]

---------------------------------
-- o and O bindings
---------------------------------
vim.cmd 'nnoremap <buffer> o A<cmd>MkdnEnter<CR>'
vim.cmd 'nnoremap <buffer> O kA<cmd>MkdnEnter<CR>'

---------------------------------
-- TOC
---------------------------------
local generateTOC = function()
	local toc = { '# Table of Contents' }
	for i = 1, vim.fn.line('$') - 1, 1 do
		local line = vim.api.nvim_buf_get_lines(0, i, i + 1, false)
		if #line > 0 and line[1]:find('^#+%s+') then
			line = line[1]
			local a, b = line:find('^#+')
			local link = require('mkdnflow.links').formatLink(line)[1]
			table.insert(toc, string.rep('\t', b - a) .. '- ' .. link)
		end
	end

	table.insert(toc, '')
	vim.fn.append(0, toc)
end

_G.MarkdownGenerateTOC = generateTOC

-- From spec.commonmark.org :
-- Left Flanking delimiter run
-- (1) not followed by Unicode whitespace, and
-- (2) either
--    (a) not followed by a Unicode punctuation character, or
--    (b) followed by a Unicode punctuation character and
--        preceded by Unicode whitespace or a Unicode punctuation character.
-- For purposes of this definition, the beginning and the end of the line count as Unicode whitespace.

-- A right-flanking delimiter run is a delimiter run that is
-- (1) not preceded by Unicode whitespace, and
-- (2) either
--    (a) not preceded by a Unicode punctuation character, or
--    (b) preceded by a Unicode punctuation character and
--        followed by Unicode whitespace or a Unicode punctuation character.
-- For purposes of this definition, the beginning and the end of the line count as Unicode whitespace.

-- Use vim.regex for left flanking delimiter and lua patterns for right
local leftEmphasis, rightEmphasis
local reStarOrUnderscore = '[\\*_]'
local reLetterFollow = ('%s[^\\p\\s]'):format(reStarOrUnderscore)
local rePuncFollow = ('[\\p\\s\\(^\\)]%s\\p'):format(reStarOrUnderscore)

local freLetterPre = ('[^\\p\\s]%s')
local frePuncPre = ('\\p%s[\\p\\s]')

local reEmphl = vim.regex(('\\(%s\\|%s\\)'):format(reLetterFollow, rePuncFollow))
local reEmphr = vim.regex(('\\(%s\\|%s\\)'):format(
	freLetterPre:format('\\*'), frePuncPre:format('\\*')
))
local reEmphr_ = vim.regex(('\\(%s\\|%s\\)'):format(
	freLetterPre:format('_'), frePuncPre:format('_')
))

local re2StarOrUnderscore = '\\(\\*\\*\\|__\\)'
reLetterFollow = ('%s[^\\p\\s]'):format(re2StarOrUnderscore)
rePuncFollow = ('[\\p\\s]%s\\p'):format(re2StarOrUnderscore)

local reStrongl = vim.regex(('\\(%s\\|%s\\)'):format(reLetterFollow, rePuncFollow))
local reStrongr = vim.regex(('\\(%s\\|%s\\)'):format(
	freLetterPre:format('\\*\\*'), frePuncPre:format('\\*\\*')
))
local reStrongr_ = vim.regex(('\\(%s\\|%s\\)'):format(
	freLetterPre:format('__'), frePuncPre:format('__')
))




--
-- @return
--    nil if the cursor is not within an closed/unclosed emphasis block,
--    emphasis _string_ if the cursor is within such a block
local function unclosedEmphasis(type)
	return leftEmphasis(vim.fn.getline('.'), 1, vim.fn.getcurpos()[3], type)
end

-- leftEmphasis and rightEmphasis form a state machine to check whether the cursor is within
-- a bold block
leftEmphasis = function(line, pos, limit, type)
	if pos > limit then
		return nil
	end

	local pattern = type == 'bold' and reStrongl or reEmphl
	local substr = line:sub(pos, limit - 1)
	-- print('looking for opening in:', substr)
	local from, to
	from, to = pattern:match_str(substr)

	if not from then
		return nil
	end

	local match = substr:sub(from + 1, to)
	-- print(('MATCHED "%s"'):format(match))

	local expect = match:find('^[%*_]') and match:sub(1, #match - 1) or match:sub(2, #match - 1)
	return rightEmphasis(line, pos + to - 1, limit, type, expect)
end

rightEmphasis = function(line, pos, limit, type, expect)
	if pos > limit then
		return expect
	end
	local pattern
	if expect == '*' then
		pattern = reEmphr
	elseif expect == '_' then
		pattern = reEmphr_
	elseif expect == '**' then
		pattern = reStrongr
	elseif expect == '__' then
		pattern = reStrongr_
	else
		error(('closeBold: got unexpected parameter: %s'):format(expect))
	end
	local substr = line:sub(pos, limit - 1)
	-- print('looking for closing in:', substr)
	local from, to
	from, to = pattern:match_str(substr)

	if not from then
		return expect
	end

	local match = substr:sub(from + 1, to + 1)
	-- print(('MATCHED "%s"'):format(match))
	local step = match:find '^[%*_]' and to + 1 or to
	return leftEmphasis(line, pos + step, limit, type)
end

------------------------------
-- Toggling Emphasis
------------------------------
local toggleEmphasis = function(type)
	if type ~= 'bold' and type ~= 'italic' then
		error('Invalid Emphasis type')
	end

	local emphasis = unclosedEmphasis(type)
	local cur = vim.fn.getcurpos()
	local line = vim.fn.getline('.')
	local s = string.reverse(line:sub(1, cur[3] - 1))
	local space
	space, s = s:find('^%s+')
	space = space and s - space + 1 or 0
	if emphasis ~= nil then
		cur = vim.fn.getcurpos()
		line = vim.fn.getline('.')
		-- TODO match case where cursor in between two '*'
		local match = vim.fn.match(line, vim.fn.escape(emphasis, '*'), cur[3] - 1, 1)
		match = match == cur[3] - 1 and emphasis:len() or -1

		-- vim.notify(('sym:%s space:%d cur:%d match:%d'):format(emphasis, space, cur[3], match))
		if match ~= -1 then
			line = line:sub(1, cur[3] - space - 1) .. emphasis .. line:sub(cur[3] + match)
			cur[3] = cur[3] - space + 2
		else
			line = line:sub(1, cur[3] - 1) .. emphasis .. line:sub(cur[3])
			cur[3] = cur[3] + emphasis:len()
		end
	else
		emphasis = config[type]
		if not emphasis then
			error("can't find default emphasis string")
		end
		line = vim.fn.getline('.')
		line = line:sub(1, cur[3] - 1) .. emphasis .. emphasis .. line:sub(cur[3])
		cur[3] = cur[3] + emphasis:len()
	end

	vim.fn.setline(cur[2], line)
	vim.fn.setpos('.', cur)
end

_G.ToggleBold = function() toggleEmphasis('bold') end
vim.cmd('imap <buffer> <C-B> <cmd>lua _G.ToggleBold()<CR>')
-- vim.cmd('imap <buffer> <C-I> <cmd>lua _G.ToggleItalic()<CR>')

------------------------------
-- Unit Tests
------------------------------

function TestRe()
	local tests = {
		{ pattern = reEmphl, text = '*Sample Text*', res = 0 },
		{ pattern = reEmphl, text = 'abc*Sample Text*', res = 3 },
		{ pattern = reEmphl, text = 'abc *Sample Text*', res = 4 },
		{ pattern = reEmphr, text = '*Sample Text.*', res = 12 },
		{ pattern = reEmphr, text = '*Sample Text*xyz', res = 11 },
		{ pattern = reEmphr, text = '*Sample Text* xyz', res = 11 },
		{ pattern = reStrongl, text = '**Sample Text**', res = 0 },
		{ pattern = reStrongl, text = 'abc**Sample Text**', res = 3 },
		{ pattern = reStrongl, text = 'abc **Sample Text**', res = 4 },
		{ pattern = reStrongr, text = '**Sample Text**', res = 12 },
		{ pattern = reStrongr, text = '**Sample Text**xyz', res = 12 },
		{ pattern = reStrongr, text = '**Sample Text** xyz', res = 12 },
	}
	for i, t in ipairs(tests) do
		local res = t.pattern:match_str(t.text)
		if res ~= t.res then
			print(('TestRe #%d expected %d got %d%'):format(i, t.res, res))
		end
	end
end

function TestOpenBold()
	local tests = {
		{ line = "line with no emphasis", limit = 10, type = 'italic', ans = false },
		{ line = "line with no emphasis", limit = 10, type = 'bold', ans = false },
		{ line = "*full emphasis*xyz", limit = 14, type = 'italic', ans = true },
		{ line = "*'full emphasis'*", limit = 18, type = 'italic', ans = false },
		{ line = "full **emphasis**", limit = 10, type = 'bold', ans = true },
		{ line = "**'full emphasis'**", limit = 20, type = 'bold', ans = false },
		{ line = "**full emphasis**", limit = 17, type = 'bold', ans = true },
		{ line = "*a* *b* *c* *d*", limit = 13, type = 'italic', ans = false },
	}
	for i, t in ipairs(tests) do
		-- print(t.line)
		if res ~= t.ans then
			print(('TestOpenBold #%d: expected %d got %d'):format(i, t.ans, res))
		end
	end
end
