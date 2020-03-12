#include "classb_vars.h"

void safe_state(void)
{
    
}

void classb_var_init(struct classb_var *var)
{
    classb_var_set(var, 0);
}

classb_type_t classb_var_get(const struct classb_var *var)
{
    if (0xFFFFFFFF != (*var->value ^ *var->value_inv))
    {
        safe_state();
    }

    return *var->value;
}

void classb_var_set(struct classb_var *var, classb_type_t val)
{
    *var->value = val;
    *var->value_inv = ~(*var->value);
}