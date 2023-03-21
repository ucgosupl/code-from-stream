cmake_minimum_required(VERSION 3.14)

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 17)

set(CMAKE_TOOLCHAIN_FILE config/Toolchain-arm-gcc.cmake)

project(freejoy)

add_subdirectory(external/FreeRTOS freeRTOS)
add_subdirectory(external/libopencm3 libopencm3)

set(INCLUDE_DIRS

)

set(C_SRCS
    main.c
    syscalls.c
)

set(LINKED_LIBS
  freertos_kernel_port
  libopencm3_stm32f4
)

set(LIB_DIRS
  external/FreeRTOS/bin/portable
  external/libopencm3/bin
)

include_directories(${INCLUDE_DIRS})
add_definitions(${GLOBAL_DEFINES})

add_executable(${CMAKE_PROJECT_NAME} ${C_SRCS})
stm32_add_linker_script(${CMAKE_PROJECT_NAME} PRIVATE ${LDSCRIPT})
target_link_directories(${CMAKE_PROJECT_NAME} PRIVATE ${LIB_DIRS})
target_link_libraries(${CMAKE_PROJECT_NAME} ${LINKED_LIBS})

add_custom_command(TARGET ${CMAKE_PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_SIZE} "${CMAKE_PROJECT_NAME}.elf")

#generate hex file
add_custom_command(TARGET ${CMAKE_PROJECT_NAME} POST_BUILD
	COMMAND ${CMAKE_OBJCOPY} -O ihex "${CMAKE_PROJECT_NAME}.elf" "${CMAKE_PROJECT_NAME}.hex"
)

# #generate extended listing
add_custom_command(TARGET ${CMAKE_PROJECT_NAME} POST_BUILD
COMMAND ${CMAKE_OBJDUMP} -h -S "${CMAKE_PROJECT_NAME}.elf" > "${CMAKE_PROJECT_NAME}.lss"
)

# #generate memory dump
add_custom_command(TARGET ${CMAKE_PROJECT_NAME} POST_BUILD
	COMMAND ${CMAKE_OBJDUMP} -x --syms "${CMAKE_PROJECT_NAME}.elf" > "${CMAKE_PROJECT_NAME}.dmp"
)