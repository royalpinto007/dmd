// EXTRA_FILES: imports/imp22749.c
/* TEST_OUTPUT:
---
fail_compilation/fail22749.d(14): Error: cannot take address of bit-field `field`
    void* ptr = &s.field;
                ^
---
*/
import imports.imp22749;

void test22749()
{
    S22749 s;
    void* ptr = &s.field;
}
