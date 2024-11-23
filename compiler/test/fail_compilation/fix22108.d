/* REQUIRED_ARGS: -preview=dip1000
TEST_OUTPUT:
---
fail_compilation/fix22108.d(14): Error: scope variable `p` may not be returned
    return *p;
           ^
---
*/

// https://issues.dlang.org/show_bug.cgi?id=22108

@safe ref int test(ref scope return int* p)
{
    return *p;
}
