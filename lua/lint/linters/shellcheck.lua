local severities = {
  error = vim.diagnostic.severity.ERROR,
  warning = vim.diagnostic.severity.WARN,
  info = vim.diagnostic.severity.INFO,
  style = vim.diagnostic.severity.HINT,
}

return {
  cmd = 'shellcheck',
  stdin = true,
  args = {
    '--format', 'json',
    '-',
  },
  ignore_exitcode = true,
  parser = function(output)
    local decoded = vim.fn.json_decode(output)
    local diagnostics = {}
    for _, item in ipairs(decoded or {}) do
      table.insert(diagnostics, {
        lnum = item.line - 1,
        col = item.column - 1,
        end_lnum = item.endLine - 1,
        end_col = item.endColumn - 1,
        user_data = {
          lsp = {
            code = item.code,
          },
        },
        severity = assert(severities[item.level], 'missing mapping for severity ' .. item.level),
        message = item.message,
      })
    end
    return diagnostics
  end,
}
