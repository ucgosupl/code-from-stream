cmake_minimum_required(VERSION 3.10)

set(CMAKE_TOOLCHAIN_FILE Toolchain-arm-gcc.cmake)

# Allow assembler
enable_language(ASM)

project(queue)

set(INCLUDE_DIRS
	../FreeRTOS/Source/include
	../FreeRTOS/Source/portable/GCC/ARM_CM4F

	../stm32
    ../cmsis
	
	src
    src/code
    src/hw
    src/utils
)

set(C_SRCS
	../../FreeRTOS/Source/croutine.c
	../../FreeRTOS/Source/event_groups.c
	../../FreeRTOS/Source/list.c
	../../FreeRTOS/Source/queue.c
	../../FreeRTOS/Source/stream_buffer.c
	../../FreeRTOS/Source/tasks.c
	../../FreeRTOS/Source/timers.c
	../../FreeRTOS/Source/portable/GCC/ARM_CM4F/port.c
	../../FreeRTOS/Source/portable/MemMang/heap_4.c

	src/freertos_hooks.c

    src/hw/core_init/core_init.c
	src/hw/gpio_f4/gpio_f4.c
	src/hw/startup/hardfault.c
    src/hw/startup/vectors.c
	
	src/utils/syscalls.c
	
	src/main.c

	src/code/buttons/buttons_task.c
	src/code/motor/motor_task.c
)

set(ASM_SRCS
    src/hw/startup/startup.S
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

# generate elf file
add_arm_executable(${CMAKE_PROJECT_NAME} ${C_SRCS} ${ASM_SRCS})

arm_link_libraries(${CMAKE_PROJECT_NAME} ${LINKED_LIBS})
