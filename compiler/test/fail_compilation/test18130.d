/*
TEST_OUTPUT:
---
fail_compilation/test18130.d(10): Error: variable `test18130.foo.v` zero-length `out` parameters are not allowed.
void foo(out byte[0] v)
                 ^
---
*/
// https://issues.dlang.org/show_bug.cgi?id=18130
void foo(out byte[0] v)
{
}
