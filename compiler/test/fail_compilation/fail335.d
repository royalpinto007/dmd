/*
TEST_OUTPUT:
---
fail_compilation/fail335.d(11): Error: cannot overload both property and non-property functions
@property void foo(int);
               ^
---
*/

void foo();
@property void foo(int);

void main()
{
    foo(1);
}
