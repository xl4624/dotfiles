return {
    'tris203/hawtkeys.nvim',
    opts = {
        leader = " ",              -- Default is space
        homerow = 2,               -- Default is 2
        powerFingers = { 2, 3, 6, 7 }, -- Default is {2,3,6,7}
        keyboardLayout = "qwerty", -- Default is qwerty
        customMaps = {
            -- Add your custom maps here
        },
        highlights = {
            HawtkeysMatchGreat = { fg = "green", bold = true },
            HawtkeysMatchGood = { fg = "green" },
            HawtkeysMatchOk = { fg = "yellow" },
            HawtkeysMatchBad = { fg = "red" },
        },
    }
}
