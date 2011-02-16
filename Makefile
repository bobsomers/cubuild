# Does the following things, in order:
#
#   1) Builds the Lua interpreter, compiler, and library from source.
#   
#   2) Compiles all cubuild Lua source files into a single precompiled Lua
#      binary (code.luac).
#   
#   3) Shoves the binary (code.luac) into a chunk of bytes in a C source
#      file (code.c).
#   
#   4) Builds a wrapper C program that just copies its arguments into a Lua
#      table and runs the embedded binary script.
#
# Cleaning removes all generated code, including the built Lua binaries.

# Name of the output binary.
BIN = cubuild

# List of the Lua source files.
LUA_SRCS = src/cubuild.lua

# Source files for Lua modules to build into the binary.
MODULE_SRCS = modules/lfs.c modules/LuaJSON_lib.c

# Directory where the Lua source code lives.
LUA_DIR = lua-5.1.4

all:
	@echo "======================================================================"
	@echo "        Building Lua from source..."
	@echo "======================================================================"
	make -C $(LUA_DIR) posix
	@echo ""
	@echo "======================================================================"
	@echo "        Compiling Lua scripts to bytecode..."
	@echo "======================================================================"
	$(LUA_DIR)/src/luac -o code.luac $(LUA_SRCS)
	$(LUA_DIR)/src/lua bin2c.lua -b -n script_code -o code.c code.luac
	@echo ""
	@echo "======================================================================"
	@echo "        Building wrapper executable..."
	@echo "======================================================================"
	gcc -O2 -Wall -I$(LUA_DIR)/src -Imodules -lm -o $(BIN) main.c $(MODULE_SRCS) $(LUA_DIR)/src/liblua.a
	@echo ""
	@echo "======================================================================"
	@echo "        All done, $(BIN) has been built successfully."
	@echo "======================================================================"

clean:
	@echo "======================================================================"
	@echo "        Cleaning Lua source..."
	@echo "======================================================================"
	make -C $(LUA_DIR) clean
	@echo ""
	@echo "======================================================================"
	@echo "        Removing generated code and binaries..."
	@echo "======================================================================"
	rm -f code.luac code.c $(BIN)
	@echo ""
	@echo "======================================================================"
	@echo "        Clean complete."
	@echo "======================================================================"

