#pragma once

#include <stdint.h>

#define CLASSB_VAR_SECTION1     __attribute__ ((section(".classb1")))
#define CLASSB_VAR_SECTION2     __attribute__ ((section(".classb2")))

typedef volatile uint32_t classb_type_t;

struct classb_var
{
    classb_type_t * const value;
    classb_type_t * const value_inv;
};

void classb_var_init(struct classb_var *var);
classb_type_t classb_var_get(const struct classb_var *var);
void classb_var_set(struct classb_var *var, classb_type_t val);
