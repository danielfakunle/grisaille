DEPS_DIR := deps
MINI_DIR := $(DEPS_DIR)/mini.nvim
LUALINE_DIR := $(DEPS_DIR)/lualine.nvim
LUALINE_REV := 221ce6b2d999187044529f49da6554a92f740a96

.PHONY: install clean test test_file lint typecheck check format format_fix

$(MINI_DIR):
	mkdir -p $(DEPS_DIR)
	git clone --filter=blob:none https://github.com/nvim-mini/mini.nvim $(MINI_DIR)

$(LUALINE_DIR):
	mkdir -p $(DEPS_DIR)
	git clone --filter=blob:none https://github.com/nvim-lualine/lualine.nvim $(LUALINE_DIR)
	git -C $(LUALINE_DIR) checkout --detach $(LUALINE_REV)

install: $(MINI_DIR) $(LUALINE_DIR)

test:
	nvim --headless --noplugin -u ./scripts/minimal_init.lua -c "lua MiniTest.run()"

test_file:
	nvim --headless --noplugin -u ./scripts/minimal_init.lua -c "lua MiniTest.run_file('$(FILE)')"

typecheck:
	VIMRUNTIME="$${VIMRUNTIME:-$$(nvim --clean --headless --cmd 'lua io.write(vim.env.VIMRUNTIME)' --cmd 'quit')}" lua-language-server --check "$(PWD)/lua" --checklevel=Warning --configpath="$(PWD)/.luarc.json"
	@echo

lint:
	luacheck lua scripts tests
	@echo

format:
	stylua --color always --respect-ignores --check .
	@echo

format_fix:
	stylua --color always --respect-ignores .
	@echo

check: format lint typecheck test

clean:
	rm -rf $(DEPS_DIR)
