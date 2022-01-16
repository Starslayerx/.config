require('bufferline').setup {
  options = {
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end,

      numbers = function(opts)
        return string.format('%s.%s', opts.ordinal, opts.lower(opts.id))
      end,

      indicator_icon = '▎',
      buffer_close_icon = '',
      modified_icon = '●',
      close_icon = '',
      left_trunc_marker = '',
      right_trunc_marker = '',

      name_formatter = function(buf)
        if buf.name:match('%.md') then
          return vim.fn.fnamemodify(buf.name, ':t:r')
        end
      end,

      custom_areas = {
        right = function()
          local result = {}
          local seve = vim.diagnostic.severity
          local error = #vim.diagnostic.get(0, {severity = seve.ERROR})
          local warning = #vim.diagnostic.get(0, {severity = seve.WARN})
          local info = #vim.diagnostic.get(0, {severity = seve.INFO})
          local hint = #vim.diagnostic.get(0, {severity = seve.HINT})

          if error ~= 0 then
            table.insert(result, {text = "  " .. error, guifg = "#EC5241"})
          end

          if warning ~= 0 then
            table.insert(result, {text = "  " .. warning, guifg = "#EFB839"})
          end

          if hint ~= 0 then
            table.insert(result, {text = "  " .. hint, guifg = "#A3BA5E"})
          end

          if info ~= 0 then
            table.insert(result, {text = "  " .. info, guifg = "#7EA9A7"})
          end
          return result
        end,
      }
  }
}
