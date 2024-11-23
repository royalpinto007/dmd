/* https://issues.dlang.org/show_bug.cgi?id=23097
REQUIRED_ARGS: -verrors=spec
TEST_OUTPUT:
---
(spec:2) compilable/test23097.d(24): Error: `inout` constructor `test23097.S23097.this` creates const object, not mutable
    static if (__traits(compiles, chunk = args))
                                          ^
(spec:2) compilable/test23097.d(24): Error: `inout` constructor `test23097.S23097.this` creates const object, not mutable
    static if (__traits(compiles, chunk = args))
                                          ^
(spec:1) compilable/test23097.d(24): Error: generated function `test23097.S23097.opAssign(S23097 p)` is not callable using argument types `(const(S23097))`
    static if (__traits(compiles, chunk = args))
                                        ^
(spec:2) compilable/test23097.d(24): Error: `inout` constructor `test23097.S23097.this` creates const object, not mutable
    static if (__traits(compiles, chunk = args))
                                          ^
(spec:1) compilable/test23097.d(24):        `struct S23097` does not define a copy constructor for `const(S23097)` to `S23097` copies
    static if (__traits(compiles, chunk = args))
                                        ^
---
*/
void emplaceRef(UT, Args)(UT chunk, Args args)
{
    static if (__traits(compiles, chunk = args))
        chunk = args;
}

struct CpCtor23097(T)
{
    T* payload;
    this(ref inout typeof(this)) { }
    ref opAssign(typeof(this)) { }
}

struct S23097
{
    CpCtor23097!int payload;
}

void test23097(S23097 lhs, const S23097 rhs)
{
    emplaceRef(lhs, rhs);
}
