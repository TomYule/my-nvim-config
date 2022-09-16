local M = {}

function M.setup()
  require("neotest").setup {
    adapters = {
      require "neotest-python" {
        dap = { justMyCode = false },
        runner = "unittest",
      },
      require "neotest-jest",
      require "neotest-go",
      require "neotest-plenary",
      require "neotest-dart" {
        command = "flutter", -- Command being used to run tests. Defaults to `flutter`
        -- Change it to `fvm flutter` if using FVM
        -- change it to `dart` for Dart only tests
      },
      require "neotest-rust",
      require "neotest-vim-test" {
        ignore_file_types = { "python", "vim", "lua", "rust", "dart" },
      },
    },
  }
end

return M
