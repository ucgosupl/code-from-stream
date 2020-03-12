cmake_minimum_required(VERSION 3.10)

set(CMAKE_TOOLCHAIN_FILE Toolchain-arm-gcc.cmake)

# Allow assembler
enable_language(ASM)

project(template_stm32f4)

#set(CMAKE_BUILD_TYPE Release)
set(CMAKE_BUILD_TYPE Debug)

set(INCLUDE_DIRS
    code
    hw
    utils
    external/stm32
    external/cmsis
)

set(CPP_SRCS
	 
)

set(C_SRCS
    code/classb_vars/classb_vars.c
    code/classb_vars/test_var.c
    hw/core_init/core_init.c
	hw/gpio_f4/gpio_f4.c
	hw/startup/hardfault.c
    hw/startup/vectors.c
	main.c
)

set(ASM_SRCS
    hw/startup/startup.S
)

set(GLOBAL_DEFINES
    -DSTM32F40_41xxx
)

set(LINKED_LIBS

)

link_directories(

)

include_directories(${INCLUDE_DIRS})
add_definitions(${GLOBAL_DEFINES})

include(compiler_flags.cmake)
#include(cppcheck.cmake)

# generate elf file
add_arm_executable(${CMAKE_PROJECT_NAME} ${CPP_SRCS} ${C_SRCS} ${ASM_SRCS})

arm_link_libraries(${CMAKE_PROJECT_NAME} ${LINKED_LIBS})
