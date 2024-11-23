/*
TEST_OUTPUT:
---
fail_compilation/fail9891.d(19): Error: expression `i` of type `immutable(int)` is not implicitly convertible to type `ref int` of parameter `n`
void f1(ref int n = i)
                    ^
fail_compilation/fail9891.d(24): Error: expression `i` of type `immutable(int)` is not implicitly convertible to type `out int` of parameter `n`
void f2(out int n = i)
                    ^
fail_compilation/fail9891.d(29): Error: cannot create default argument for `ref` / `out` parameter from expression `prop()` because it is not an lvalue
void f3(ref int n = prop)
                    ^
---
*/

immutable int i;
int prop() { return 0; }

void f1(ref int n = i)
{
    ++n;
}

void f2(out int n = i)
{
    ++n;
}

void f3(ref int n = prop)
{
    ++n;
}
