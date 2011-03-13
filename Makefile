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
LUA_SRCS = src/lualogging-1.1.4/logging.lua \
		   src/lualogging-1.1.4/console.lua \
		   src/lualogging-1.1.4/file.lua \
		   src/luajson-1.2.1/json.lua \
		   src/luajson-1.2.1/json/util.lua \
		   src/luajson-1.2.1/json/decode.lua \
		   src/luajson-1.2.1/json/encode.lua \
		   src/luajson-1.2.1/json/decode/array.lua \
		   src/luajson-1.2.1/json/decode/calls.lua \
		   src/luajson-1.2.1/json/decode/number.lua \
		   src/luajson-1.2.1/json/decode/object.lua \
		   src/luajson-1.2.1/json/decode/others.lua \
		   src/luajson-1.2.1/json/decode/strings.lua \
		   src/luajson-1.2.1/json/decode/util.lua \
		   src/luajson-1.2.1/json/encode/array.lua \
		   src/luajson-1.2.1/json/encode/calls.lua \
		   src/luajson-1.2.1/json/encode/number.lua \
		   src/luajson-1.2.1/json/encode/object.lua \
		   src/luajson-1.2.1/json/encode/others.lua \
		   src/luajson-1.2.1/json/encode/output.lua \
		   src/luajson-1.2.1/json/encode/output_utility.lua \
		   src/luajson-1.2.1/json/encode/strings.lua \
		   src/luajson-1.2.1/json.lua \
		   src/cubuild.lua

# Source files for Lua modules to build into the binary.
MODULE_SRCS = src/luafilesystem-1.5.0/lfs.c \
			  src/lpeg-0.10.2/lpeg.c

# Directory where the Lua source code lives.
LUA_DIR = src/lua-5.1.4

all:
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
	gcc -O2 -Wall -I$(LUA_DIR)/src -Isrc -I$(GEN_DIR) -lm -o $(BIN) src/main.c $(MODULE_SRCS) $(LUA_DIR)/src/liblua.a
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

