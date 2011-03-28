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

# Directory where source files live.
SRC_DIR = src

# Directory where utility tools live.
TOOLS_DIR = tools

# Directory where generated code goes.
GEN_DIR = gen

# List of the Lua source files.
LUA_SRCS = $(SRC_DIR)/globals.lua \
		   $(GEN_DIR)/build_info.lua \
		   $(SRC_DIR)/cmd_args.lua \
		   $(SRC_DIR)/primitives.lua \
		   $(SRC_DIR)/cubuild.lua

# Source files for Lua modules to build into the binary.
MODULE_SRCS = $(SRC_DIR)/luafilesystem-1.5.0/lfs.c

# Directory where the Lua source code lives.
LUA_DIR = $(SRC_DIR)/lua-5.1.4

all:
	@echo "======================================================================"
	@echo "        Generating build info..."
	@echo "======================================================================"
	echo "BUILD_DATE = [[" > $(GEN_DIR)/build_info.lua
	date >> $(GEN_DIR)/build_info.lua
	echo "]]" >> $(GEN_DIR)/build_info.lua
	echo "BUILD_MACHINE = [[" >> $(GEN_DIR)/build_info.lua
	hostname -s >> $(GEN_DIR)/build_info.lua
	echo "]]" >> $(GEN_DIR)/build_info.lua
	echo "BUILD_ARCH = [[" >> $(GEN_DIR)/build_info.lua
	uname -i >> $(GEN_DIR)/build_info.lua
	echo "]]" >> $(GEN_DIR)/build_info.lua
	echo "GIT_COMMIT = [[" >> $(GEN_DIR)/build_info.lua
	git rev-parse HEAD >> $(GEN_DIR)/build_info.lua
	echo "]]" >> $(GEN_DIR)/build_info.lua
	@echo ""
	@echo "======================================================================"
	@echo "        Building Lua from source..."
	@echo "======================================================================"
	make -C $(LUA_DIR) posix
	@echo ""
	@echo "======================================================================"
	@echo "        Compiling Lua scripts to bytecode..."
	@echo "======================================================================"
	$(LUA_DIR)/src/luac -o $(GEN_DIR)/code.luac $(LUA_SRCS)
	$(LUA_DIR)/src/lua $(TOOLS_DIR)/bin2c.lua -b -n script_code -o $(GEN_DIR)/code.c $(GEN_DIR)/code.luac
	@echo ""
	@echo "======================================================================"
	@echo "        Building wrapper executable..."
	@echo "======================================================================"
	gcc -O2 -Wall -I$(LUA_DIR)/src -I$(SRC_DIR) -I$(GEN_DIR) -lm -o $(BIN) $(SRC_DIR)/main.c $(MODULE_SRCS) $(LUA_DIR)/src/liblua.a
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
	rm -f $(GEN_DIR)/code.luac $(GEN_DIR)/code.c $(BIN)
	@echo ""
	@echo "======================================================================"
	@echo "        Clean complete."
	@echo "======================================================================"

