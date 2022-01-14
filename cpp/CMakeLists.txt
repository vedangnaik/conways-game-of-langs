cmake_minimum_required(VERSION 3.10)
project(game_of_langs_cpp VERSION 1.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# https://github.com/p-ranav/argparse v2.2
include(FetchContent)
FetchContent_Declare(
    argparse
    GIT_REPOSITORY https://github.com/p-ranav/argparse.git
    GIT_TAG b0cb28ab177cdbd19d439c02cdc217bdfc508ba9
)
FetchContent_MakeAvailable(argparse)

add_executable(main
    main.cpp
    Board.cpp
)
#target_compile_options(main PRIVATE /Wall)

target_include_directories(main PUBLIC
    "${argparse_SOURCE_DIR}/include"
)