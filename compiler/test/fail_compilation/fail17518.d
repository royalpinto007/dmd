/*
TEST_OUTPUT:
---
fail_compilation/fail17518.d(23): Error: constructor `fail17518.S.this(inout(Correct) __param_0) inout` is not callable using argument types `(Wrong)`
    return S(Wrong());
            ^
fail_compilation/fail17518.d(23):        cannot pass argument `Wrong()` of type `Wrong` to parameter `inout(Correct) __param_0`
---
*/

struct S
{
    this(inout Correct) inout
    {
    }
}

struct Correct {}
struct Wrong {}

S bug()
{
    return S(Wrong());
}
