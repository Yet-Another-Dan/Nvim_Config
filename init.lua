vim.opt.nu = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.signcolumn = 'yes'

-- set where splits appear
vim.opt.splitright = true
vim.opt.splitbelow = true

-- show live substitutions
vim.opt.inccommand = 'split'

-- show which line cursor is on
vim.opt.cursorline = true

-- min lines above and below cursor when scrolling
vim.opt.scrolloff = 10
vim.opt.sidescroll = 10

vim.opt.incsearch = true
vim.opt.termguicolors = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({count=-1}) end, { desc = 'Go to previous Diagnostic message' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({count= 1}) end, { desc = 'Go to next Diagnostic message' })


vim.opt.completeopt = {"menuone", "noselect", "popup"}

vim.lsp.config["lua-language-server"] = {
  cmd = {"lua-language-server"},
  root_markers = { ".luarc.json", "init.lua" },
  filetypes = { "lua" },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  }
}



vim.lsp.config["clangd"] = {
  cmd = {"clangd"},
  root_markers = {"compile_commands.json",".clangd","compile_flags.txt"},
  filetypes = { "c","cpp","objc","objcpp","cuda","proto"},
}

vim.lsp.config["pyright"] = {
  cmd = {"pyright-langserver", "--stdio"},
  root_markers = {"main.py"},
  filetypes = { "python","py"},
}

vim.lsp.config["texlab"] = {
  cmd = {"texlab"},
  root_markers = {".git", "Tectonic.toml","texlabroot",".latexmkrc","main.tex"},
  filetypes = {"tex", "plaintex", "latex", "bib"},
  settings = {
    texlab = {
      build = {
        executable = "tectonic",
        args = {
          "-X",
          "compile",
          "%f",
          [[--synctex]],
          [[--keep-logs]],
          [[--keep-intermediates]],
        }
      }
    }
  }
}

vim.lsp.enable({"lua-language-server","clangd","pyright","texlab"})


vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local bufnr = ev.buf
    if client ~= nil and client:supports_method('textDocument/completion') then

      -- enable lsp completion
      vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = true})

      -- set omnifunc, may be redundant
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      vim.api.nvim_create_autocmd("InsertCharPre", {
        buffer = bufnr,
        callback = function()
          local col = vim.fn.col('.') - 1
          if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
            return
          end
          vim.schedule(function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-x><C-o>', true, true, true), 'n', false)
          end)
        end
      })

    end
  end,
})

vim.cmd("set completeopt+=noselect")

vim.opt.pumheight = 5




require("config.lazy")
require("ibl").setup()


local colors = {
  red = '#ca1243',
  grey = '#a0a1a7',
  black = '#383a42',
  white = '#f3f3f3',
  light_green = '#83a598',
  orange = '#fe8019',
  green = '#8ec07c',
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'solarized_dark',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      {'diagnostics',
        source = {'nvim'},
        sections = {'error'},
        diagnostics_color = {warn = {bg = colors.orange, fg = colors.white}},
      },
      {'diagnostics',
        source = {'nvim'},
        sections = {'warn'},
        diagnostics_color = {warn = {bg = colors.red, fg = colors.white}},
      },
    },
    lualine_c = {{'filename', file_status = false, path = 2}},
    lualine_x = {'encoding','filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

if vim.g.neovide then
	vim.g.neovide_opacity = .5
	vim.g.transparency = .5
	vim.g.neovide_cursor_vfx_mode = "wireframe"

	vim.o.guifont = "monocraft:h12:b"

end
