NVIM_FLAGS := --headless --noplugin --clean
MINIMAL_INIT := tests/minimal_init.lua
TEST_COMMAND := PlenaryBustedDirectory tests/ { minimal_init = '$(MINIMAL_INIT)' }

.PHONY: test

test:
	@nvim $(NVIM_FLAGS) -u $(MINIMAL_INIT) -c "$(TEST_COMMAND)"
