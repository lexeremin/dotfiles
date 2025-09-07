-- Compatibility shim for LazyVim calling `catppuccin.groups.integrations.bufferline.get()`
-- Newer catppuccin versions may not expose this. Returning an empty table is safe.
return {
  get = function()
    return {}
  end,
}


