/*
 * File:    linker.ld
 * Author:  GAndaLF
 * Brief:   Linker script for STM32F407VG.
 */

/******************************************************************************
 * Initial configuration
 *****************************************************************************/

SEARCH_DIR(.);
OUTPUT_FORMAT ("elf32-littlearm", "elf32-bigarm", "elf32-littlearm");
OUTPUT_ARCH(arm);

/******************************************************************************
 * Defines for memory regions for chip: STM32F407VG
 ******************************************************************************
 * Memory map with flash, ram, ccm and backup domain sections. In RAM
 * there is separated aux_ram section which is optimized for ETH/USB buffers.
 * Constants containing beggining, end and size of every section are available
 * in the code.
 */

MEMORY
{
	rom (rx)		: org = 0x08000000, len = 1024k
	ram (rwx)		: org = 0x20000000, len = 112k
	aux_ram (rwx)	: org = 0x2001C000, len = 16k
	ccm_ram (rwx)	: org = 0x10000000, len = 64k
	bkp_ram (rwx)	: org = 0x40024000, len = 4k
}

/******************************************************************************
 * Definitions of the beginning, end, and size of various regions.
 *****************************************************************************/
__rom_start = ORIGIN(rom);
__rom_size = LENGTH(rom);
__rom_end = __rom_start + __rom_size;

__ram_start = ORIGIN(ram);
__ram_size = LENGTH(ram);
__ram_end = __ram_start + __ram_size;

__aux_ram_start = ORIGIN(aux_ram);
__aux_ram_size = LENGTH(aux_ram);
__aux_ram_end = __aux_ram_start + __aux_ram_size;

__ccm_ram_start = ORIGIN(ccm_ram);
__ccm_ram_size = LENGTH(ccm_ram);
__ccm_ram_end = __ccm_ram_start + __ccm_ram_size;

__bkp_ram_start = ORIGIN(bkp_ram);
__bkp_ram_size = LENGTH(bkp_ram);
__bkp_ram_end = __bkp_ram_start + __bkp_ram_size;

/******************************************************************************
 * Exporting definitions to be used in program. They are available if program
 * doesn't define variable with the same name.
 *****************************************************************************/
PROVIDE(__rom_start = __rom_start);
PROVIDE(__rom_size = __rom_size);
PROVIDE(__rom_end = __rom_end);

PROVIDE(__ram_start = __ram_start);
PROVIDE(__ram_size = __ram_size);
PROVIDE(__ram_end = __ram_end);

PROVIDE(__aux_ram_start = __aux_ram_start);
PROVIDE(__aux_ram_size = __aux_ram_size);
PROVIDE(__aux_ram_end = __aux_ram_end);

PROVIDE(__ccm_ram_start = __ccm_ram_start);
PROVIDE(__ccm_ram_size = __ccm_ram_size);
PROVIDE(__ccm_ram_end = __ccm_ram_end);

PROVIDE(__bkp_ram_start = __bkp_ram_start);
PROVIDE(__bkp_ram_size = __bkp_ram_size);
PROVIDE(__bkp_ram_end = __bkp_ram_end);

__stack_size = 512;

PROVIDE(__stack_size = __stack_size);

/*******************************************************************************
 * Entry point
 ******************************************************************************/

ENTRY(Reset_Handler);

/******************************************************************************
 * Assigning data to memory regions
 *****************************************************************************/
 
 SECTIONS
 {
 	.text :
 	{
 		. = ALIGN(4);
		__text_start = .;
		PROVIDE(__text_start = __text_start);

		. = ALIGN(4);
		KEEP(*(.vectors));
		
		. = ALIGN(4);
		*(.text .text.* .gnu.linkonce.t.*);
		. = ALIGN(4);
		*(.glue_7t .glue_7);
		. = ALIGN(4);
		*(.rodata .rodata.* .gnu.linkonce.r.*);

		/* exception unwinding information */
		. = ALIGN(4);
		*(.ARM.extab* .gnu.linkonce.armextab.*);

		/* information used for stack unwinding during exception */
		. = ALIGN(4);
		*(.gcc_except_table);

		/* additional information about .ex_frame section */
		. = ALIGN(4);
		*(.eh_frame_hdr);

		/* information used for stack unwinding during exception */
		. = ALIGN(4);
		*(.eh_frame);

		. = ALIGN(4);
		KEEP(*(.init));

		. = ALIGN(4);
		__preinit_array_start = .;
		KEEP(*(.preinit_array));		
		. = ALIGN(4);
		__preinit_array_end = .;

		__init_array_start = .;
		KEEP(*(SORT(.init_array.*)));
		. = ALIGN(4);
		KEEP(*(.init_array));
		. = ALIGN(4);
		__init_array_end = .;

		KEEP(*(.fini));
		. = ALIGN(4);

		__fini_array_start = .;
		KEEP(*(.fini_array));
		. = ALIGN(4);
		KEEP(*(SORT(.fini_array.*)));
		. = ALIGN(4);
		__fini_array_end = .;

		. = ALIGN(4);
		__text_end = .;
		PROVIDE(__text_end = __text_end);
 	} > rom AT > rom
 	
 	/* index entries for section unwinding */
 	. = ALIGN(4);
	__exidx_start = .;
	PROVIDE(__exidx_start = __exidx_start);

	.ARM.exidx :
	{
		*(.ARM.exidx* .gnu.linkonce.armexidx.*);
	} > rom AT > rom

	. = ALIGN(4);
	__exidx_end = .;
	PROVIDE(__exidx_end = __exidx_end);
	
	/*
	 * RAM data initialized with values other than 0. Starting values are stored
	 * in the flash memory.
	 */
	.data :
	{
		. = ALIGN(4);
		__data_init_start = LOADADDR (.data);
		PROVIDE(__data_init_start = __data_init_start);
		__data_start = .;
		PROVIDE(__data_start = __data_start);

		. = ALIGN(4);
		*(.data .data.* .gnu.linkonce.d.*)

		. = ALIGN(4);
		__data_end = .;
		PROVIDE(__data_end = __data_end);
	} > ram AT > rom
	
	/*
	 * RAM data initialized with zeroes.
	 */
	.bss :
	{
		. = ALIGN(4);
		__bss_start = .;
		PROVIDE(__bss_start = __bss_start);

		. = ALIGN(4);
		*(.bss .bss.* .gnu.linkonce.b.*)
		. = ALIGN(4);
		*(COMMON);

		. = ALIGN(4);
		__bss_end = .;
		PROVIDE(__bss_end = __bss_end);
	} > ram AT > ram

	.stack :
	{
		. = ALIGN(8);
		__stack_start = .;
		PROVIDE(__stack_start = __stack_start);

		. += __stack_size;

		. = ALIGN(8);
		__stack_end = .;
		PROVIDE(__stack_end = __stack_end);
	} > ram AT > ram
	
	. = ALIGN(4);
	__heap_start = .;
	PROVIDE(__heap_start = __heap_start);

	. = ALIGN(4);
	__heap_end = __ram_end;
	PROVIDE(__heap_end = __heap_end);
	
	.stab 				0 (NOLOAD) : { *(.stab) }
	.stabstr 			0 (NOLOAD) : { *(.stabstr) }
	/* DWARF debug sections.
	* Symbols in the DWARF debugging sections are relative to the beginning
	* of the section so we begin them at 0. */
	/* DWARF 1 */
	.debug				0 : { *(.debug) }
	.line				0 : { *(.line) }
	/* GNU DWARF 1 extensions */
	.debug_srcinfo		0 : { *(.debug_srcinfo) }
	.debug_sfnames		0 : { *(.debug_sfnames) }
	/* DWARF 1.1 and DWARF 2 */
	.debug_aranges		0 : { *(.debug_aranges) }
	.debug_pubnames		0 : { *(.debug_pubnames) }
	/* DWARF 2 */
	.debug_info			0 : { *(.debug_info .gnu.linkonce.wi.*) }
	.debug_abbrev		0 : { *(.debug_abbrev) }
	.debug_line			0 : { *(.debug_line) }
	.debug_frame		0 : { *(.debug_frame) }
	.debug_str			0 : { *(.debug_str) }
	.debug_loc			0 : { *(.debug_loc) }
	.debug_macinfo		0 : { *(.debug_macinfo) }
	/* SGI/MIPS DWARF 2 extensions */
	.debug_weaknames	0 : { *(.debug_weaknames) }
	.debug_funcnames	0 : { *(.debug_funcnames) }
	.debug_typenames	0 : { *(.debug_typenames) }
	.debug_varnames		0 : { *(.debug_varnames) }

	.note.gnu.arm.ident	0 : { KEEP(*(.note.gnu.arm.ident)) }
	.ARM.attributes		0 : { KEEP(*(.ARM.attributes)) }
	/DISCARD/				: { *(.note.GNU-stack) }	
 }

PROVIDE(__text_size = __text_end - __text_start);
PROVIDE(__exidx_size = __exidx_end - __exidx_start);
PROVIDE(__data_size = __data_end - __data_start);
PROVIDE(__bss_size = __bss_end - __bss_start);
PROVIDE(__heap_size = __heap_end - __heap_start);
