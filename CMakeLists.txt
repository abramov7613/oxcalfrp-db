cmake_minimum_required(VERSION 3.25)

project(oxcalfrp_db)

# download CPM.cmake
set(CPM__URL "https://github.com/cpm-cmake/CPM.cmake/releases/download/v0.42.0/CPM.cmake")
set(CPM__SHA256 "2020b4fc42dba44817983e06342e682ecfc3d2f484a581f11cc5731fbe4dce8a")
set(CPM__PATH "${CMAKE_CURRENT_SOURCE_DIR}/CPM.cmake")
set(CPM__CURRENT_HASH "")
if(EXISTS ${CPM__PATH})
  file(SHA256 ${CPM__PATH} CPM__CURRENT_HASH)
endif()
if(NOT CPM__CURRENT_HASH STREQUAL CPM__SHA256)
  file(
    DOWNLOAD
    ${CPM__URL}
    ${CPM__PATH}
    EXPECTED_HASH SHA256=${CPM__SHA256}
  )
endif()
set(CPM_SOURCE_CACHE ${CMAKE_CURRENT_SOURCE_DIR}/extern)
include(${CPM__PATH})

# download Lua
CPMAddPackage(
  NAME lua
  VERSION 5.4.8
  URL "https://www.lua.org/ftp/lua-5.4.8.tar.gz"
  URL_HASH SHA256=4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae
  DOWNLOAD_ONLY YES
)
if (NOT lua_ADDED)
  message(FATAL_ERROR "Can't get Lua!")
endif()
set(lua_SOURCE_DIR "${lua_SOURCE_DIR}/src")
FILE(GLOB lualib_sources ${lua_SOURCE_DIR}/*.c)
list(REMOVE_ITEM lualib_sources "${lua_SOURCE_DIR}/lua.c" "${lua_SOURCE_DIR}/luac.c")
set(luaint_sources "${lua_SOURCE_DIR}/lua.c")
add_library(lua SHARED ${lualib_sources})
target_include_directories(lua
  PUBLIC
    $<BUILD_INTERFACE:${lua_SOURCE_DIR}>
)
add_executable(lua_interpreter ${luaint_sources})

# download SQLite
CPMAddPackage(
  NAME sqlite3
  URL "https://github.com/abramov7613/sqlite-amalgamation-mirror/archive/refs/heads/main.zip"
  URL_HASH SHA256=e5767bdc60c09b31066c534a3dc3d4bd5d335377b443c4aa67ff5fa6a9746791
  DOWNLOAD_ONLY TRUE
)
if(NOT sqlite3_ADDED)
  message(FATAL_ERROR "Can't get SQLite3!")
endif()
add_library(sqlite3 SHARED ${sqlite3_SOURCE_DIR}/sqlite3.c)
target_include_directories(sqlite3 PUBLIC $<BUILD_INTERFACE:${sqlite3_SOURCE_DIR}>)

# download lSQLite
CPMAddPackage(
  NAME lsqlite3
  URL "https://github.com/abramov7613/lsqlite3-mirror/archive/refs/heads/main.zip"
  URL_HASH SHA256=b40c64b138eca1626e36cce07cb93c48a51f18c234b57f0e4370d53f2400b5cf
  DOWNLOAD_ONLY TRUE
)
if(NOT lsqlite3_ADDED)
  message(FATAL_ERROR "Can't get lsqlite3!")
endif()
add_library(lsqlite3 SHARED ${lsqlite3_SOURCE_DIR}/lsqlite3.c)
target_include_directories(lsqlite3 PUBLIC $<BUILD_INTERFACE:${lsqlite3_SOURCE_DIR}>)
target_include_directories(lsqlite3 PRIVATE ${lua_SOURCE_DIR})

# set targets properties
set_target_properties(lua PROPERTIES PREFIX "")
set_target_properties(sqlite3 PROPERTIES PREFIX "")
set_target_properties(lsqlite3 PROPERTIES PREFIX "")
target_compile_definitions(lua PRIVATE
  $<$<PLATFORM_ID:Linux>:LUA_USE_LINUX>
  $<$<PLATFORM_ID:Darwin>:LUA_USE_MACOSX>
)
target_link_libraries(lsqlite3 PRIVATE lua sqlite3)
target_link_libraries(lua_interpreter PRIVATE
  lua
  sqlite3
  $<$<PLATFORM_ID:Linux>:m>
)

# define database targets
set(DB_SRCS
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pisanie.lua
#  ${CMAKE_CURRENT_SOURCE_DIR}/src/irmologi.lua
)
foreach(SRC IN LISTS DB_SRCS)
  cmake_path(GET SRC STEM DBNAME)
  set(DBOUTFILE "${DBNAME}.sqlite3")
  add_custom_command(
    OUTPUT
      ${DBOUTFILE}
    DEPENDS
      ${SRC}
    COMMAND
      ${CMAKE_COMMAND} -E rm -f ${DBOUTFILE}
    COMMAND
      lua_interpreter ${SRC} ${DBOUTFILE}
    VERBATIM
  )
  add_custom_target("${DBNAME}" ALL
    DEPENDS
      ${DBOUTFILE}
      lua_interpreter
    VERBATIM
  )
endforeach()
