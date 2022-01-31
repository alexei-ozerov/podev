local M = {}
M.plugins = {
   options = {
      lspconfig = {
         setup_lspconf = "custom.plugins.lspconfig",
      },
   },
}
M.ui = {
   theme = "onedark",
}
return M