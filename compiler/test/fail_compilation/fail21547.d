// https://issues.dlang.org/show_bug.cgi?id=21547

/*
TEST_OUTPUT:
---
fail_compilation/fail21547.d(36): Error: struct `Bar` has constructors, cannot use `{ initializers }`, use `Bar( initializers )` instead
    Bar b = { a: "Hello", b: 42 };
            ^
fail_compilation/fail21547.d(37): Error: struct `Bar1` has constructors, cannot use `{ initializers }`, use `Bar1( initializers )` instead
    Bar1 b1 = { a: "Hello", b: 42 };
              ^
---
*/

struct Bar
{
    @disable this(int a) {}
    this(int a, int b) {}

    string a;
    uint b;
}

struct Bar1
{
    @disable this(int a) {}
    this(const ref Bar1 o) {}
    this(int a, int b) {}

    string a;
    uint b;
}

void main ()
{
    Bar b = { a: "Hello", b: 42 };
    Bar1 b1 = { a: "Hello", b: 42 };
}
