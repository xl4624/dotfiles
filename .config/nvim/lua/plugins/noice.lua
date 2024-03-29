return {
  "folke/noice.nvim",
    -- stylua: ignore
    keys = {
    { "<leader>snl", false},
    { "<leader>snh", false},
    { "<leader>sna", false},
    { "<leader>snd", false},

    { "<leader>nl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    { "<leader>nh", function() require("noice").cmd("history") end, desc = "Noice History" },
    { "<leader>na", function() require("noice").cmd("all") end, desc = "Noice All" },
    { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
    { "<leader>nD", function() require("noice").cmd("disable") end, desc = "Disable Noice" },
    { "<leader>ne", function() require("noice").cmd("enable") end, desc = "Enable Noice" },
    },
}
