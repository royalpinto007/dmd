/*
EXTRA_FILES: imports/constraints.d
TEST_OUTPUT:
---
fail_compilation/constraints_aggr.d(44): Error: template `f` is not callable using argument types `!()(int)`
    c.f(0);
       ^
fail_compilation/imports/constraints.d(60):        Candidate is: `f(T)(T v)`
  with `T = int`
  must satisfy the following constraint:
`       !P!T`
    void f(T)(T v) if (P!T && !P!T)
         ^
fail_compilation/constraints_aggr.d(45): Error: template `g` is not callable using argument types `!()()`
    c.g();
       ^
fail_compilation/imports/constraints.d(63):        Candidate is: `g(this T)()`
  with `T = imports.constraints.C`
  must satisfy the following constraint:
`       N!T`
    void g(this T)() if (N!T)
         ^
fail_compilation/constraints_aggr.d(47): Error: template instance `imports.constraints.S!int` does not match template declaration `S(T)`
  with `T = int`
  must satisfy the following constraint:
`       N!T`
    S!int;
    ^
fail_compilation/constraints_aggr.d(56): Error: template instance `imports.constraints.BitFlags!(Enum)` does not match template declaration `BitFlags(E, bool unsafe = false)`
  with `E = Enum`
  must satisfy one of the following constraints:
`       unsafe
       N!E`
    BitFlags!Enum flags;
    ^
---
*/

void main()
{
    import imports.constraints;

    C c = new C;
    c.f(0);
    c.g();

    S!int;

    enum Enum
    {
        A = 1,
        B = 2,
        C = 4,
        BC = B|C
    }
    BitFlags!Enum flags;
}
