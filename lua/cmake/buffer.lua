local bufnr = -1

local buffer = {}

function buffer.open_split(title)
  local is_visable = vim.api.nvim_call_function("bufwinnr", { bufnr }) ~= -1
  if bufnr == -1 or not is_visable then
    vim.cmd([[botright split]])
    local handle = vim.api.nvim_tabpage_get_win(0)
    bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(handle, bufnr)

    vim.api.nvim_buf_set_lines(bufnr, 0, -1 + 2, true, title)
    vim.api.nvim_buf_set_name(bufnr, "cmake output")
    vim.api.nvim_buf_set_option(bufnr, "readonly", true)
    vim.api.nvim_buf_set_option(bufnr, "modified", false)
    vim.api.nvim_buf_set_option(bufnr, "bufhidden", "delete")
  end
end

function buffer.append_line(_, data)
  if data then
    vim.api.nvim_buf_set_option(bufnr, "readonly", false)
    vim.api.nvim_buf_set_lines(bufnr, -1, -1, true, data)
    vim.api.nvim_buf_set_option(bufnr, "readonly", true)
    vim.api.nvim_buf_set_option(bufnr, "modified", "delete")
  end
end

return buffer
