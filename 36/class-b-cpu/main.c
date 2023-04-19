/*
 * This file is part of the libopencm3 project.
 *
 * Copyright (C) 2009 Uwe Hermann <uwe@hermann-uwe.de>
 * Copyright (C) 2011 Stephen Caudle <scaudle@doceme.com>
 *
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "platform_specific.h"
#include "rtos_wrappers.h"
#include <stdlib.h>

#include "core_init/core_init.h"

static void dummy_task(void *params);

void dummy_task_init(void)
{
    rtos_task_create(dummy_task, "dummy", RTOS_TASK_STACKSIZE_MIN, RTOS_PRIORITY_MIN + 1);
}

int main(void)
{
	core_init();

	dummy_task_init();

	rtos_start_scheduler();

	while (1)
		;

	return 0;
}

static void dummy_task(void *params)
{
	while (1)
	{
		rtos_delay(rtos_ms_to_ticks(1000));
	}
}

int32_t classb_cpu_startup(void);

void low_level_init_0(void)
{
	if (0 == classb_cpu_startup())
	{
		return;
	}

	return;
}

void low_level_init_1(void)
{

}