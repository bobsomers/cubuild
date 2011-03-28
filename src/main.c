#include <stdio.h>
#include <stdlib.h>

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#include "luafilesystem-1.5.0/lfs.h"

#include "code.c"

int main(int argc, char *argv[]) {
    int i = 0;
    lua_State *L = NULL;
    
    // create lua state and load libraries
    L = luaL_newstate();
    luaL_openlibs(L);
    luaopen_lfs(L);
    
    // create and fill args table
    lua_newtable(L);
    for (i = 0; i < argc; i++) {
        lua_pushnumber(L, i);
        lua_pushstring(L, argv[i]);
        lua_rawset(L, -3);
    }

    // set the global arg table
    lua_setglobal(L, "arg");

    // run the embedded script
    if (luaL_loadbuffer(L, (const char *)script_code, script_code_len, "script_code") ||
        lua_pcall(L, 0, LUA_MULTRET, 0)) {
        fprintf(stderr, "%s\n", lua_tostring(L, -1));
        exit(EXIT_FAILURE);
    }

    // shut down the lua vm
    lua_close(L);

    return EXIT_SUCCESS;
}
