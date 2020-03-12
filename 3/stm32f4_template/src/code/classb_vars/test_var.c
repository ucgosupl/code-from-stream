#include "test_var.h"

static classb_type_t test_var_b1 CLASSB_VAR_SECTION1 = 0;
static classb_type_t test_var_b2 CLASSB_VAR_SECTION2 = 0;

static struct classb_var test_var = {&test_var_b1, &test_var_b2};

void classb_test_var_init(void)
{
    classb_var_init(&test_var);
}

classb_type_t classb_test_var_get(void)
{
    return classb_var_get(&test_var);
}

void classb_test_var_set(classb_type_t val)
{
    classb_var_set(&test_var, val);
}