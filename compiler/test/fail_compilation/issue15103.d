/*
TEST_OUTPUT:
----
fail_compilation/issue15103.d(28): Error: found `(` when expecting `;` or `=`, did you mean `Foo foo = 42`?
    Foo foo(42);
        ^
fail_compilation/issue15103.d(29): Error: found `(` when expecting `;` or `=`, did you mean `Boo boo = 43`?
    Boo boo(43);
        ^
fail_compilation/issue15103.d(30): Error: found `(` when expecting `;` or `=`, did you mean `string y = "a string"`?
    string y("a string");
           ^
---
*/

struct Foo
{
    this(int x) {}
}

class Boo
{
    this(int x) {}
}

void main ()
{
    Foo foo(42);
    Boo boo(43);
    string y("a string");
}
