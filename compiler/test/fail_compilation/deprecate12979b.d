// REQUIRED_ARGS: -de

/*
TEST_OUTPUT:
---
fail_compilation/deprecate12979b.d(14): Error: `asm` statement is assumed to be impure - mark it with `pure` if it is not
    asm
    ^
---
*/

void foo() pure
{
    asm
    {
        ret;
    }
}
