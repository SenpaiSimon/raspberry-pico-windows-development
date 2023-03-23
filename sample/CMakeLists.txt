cmake_minimum_required(VERSION 3.12)

# Change your executable name to something creative!
set(NAME MyProject) # <-- Name your project/executable here!

include($ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake)

# Gooey boilerplate
set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
project(${NAME} C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# Initialize the SDK
pico_sdk_init()

add_compile_options(-Wall
        -Wno-format          # int != int32_t as far as the compiler is concerned because gcc has int32_t as long int
        -Wno-unused-function # we have some for the docs that aren't called
        -Wno-maybe-uninitialized
        )

# Include Library cmake lists

# Add your source files
add_executable(${NAME}
    main.c # <-- Add source files here!
)


# Don't forget to link the libraries you need!
target_link_libraries(${NAME}
    pico_stdlib # <-- Libs here
)

# enable usb output, disable uart output
pico_enable_stdio_uart(${NAME} 0)
pico_enable_stdio_usb(${NAME} 1)

# create map/bin/hex file etc.
pico_add_extra_outputs(${NAME})

# Set up files for the release packages
install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/${NAME}.uf2
    ${CMAKE_CURRENT_LIST_DIR}/README.md
    DESTINATION .
)

set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY OFF)
set(CPACK_GENERATOR "ZIP" "TGZ")
include(CPack)