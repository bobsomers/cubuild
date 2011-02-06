#include <stdio.h>
#include <stdlib.h>

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#include "code.c"

int main(int argc, char *argv[]) {
    int i = 0;
    lua_State *L = NULL;
    
    // create lua state and args table
    L = luaL_newstate();
    luaL_openlibs(L);
    lua_newtable(L);
    
    // fill args table
    for (i = 0; i < argc; i++) {
        lua_pushnumber(L, i);
        lua_pushstring(L, argv[i]);
        lua_rawset(L, -3);
    }

    // set the args table
    lua_setglobal(L, "args");

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
