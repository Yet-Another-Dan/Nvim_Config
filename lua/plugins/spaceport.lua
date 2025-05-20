return {
    'CWood-sdf/spaceport.nvim',
    opts = {
	maxRecentFiles = 5,
	sections = {
		{
			"name",
			config = {
				style = "lite",
				gradient = "blue_green",
			},
		},
		{
			"remaps",
			title = "Remaps",
		},
		{
			"recents",
		},
	}
    },
    lazy = false, -- load spaceport immediately
}
