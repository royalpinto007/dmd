/*
TEST_OUTPUT:
---
fail_compilation/fail13123.d(13): Error: `fail13123.test`: `in` contract may throw but function is marked as `nothrow`
void test() nothrow
     ^
fail_compilation/fail13123.d(13): Error: `fail13123.test`: `out` contract may throw but function is marked as `nothrow`
void test() nothrow
     ^
---
*/

void test() nothrow
in
{
    throw new Exception(null);
}
out
{
    throw new Exception(null);
}
do
{
}
