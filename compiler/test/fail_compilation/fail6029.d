/*
TEST_OUTPUT:
---
fail_compilation/fail6029.d(12): Error: alias this is not reachable as `A` already converts to `A`
    alias a this;
    ^
---
*/
struct A
{
    static A a;
    alias a this;
}

void foo(A a)
{
}

void main()
{
//  foo(A);    // Error: type A is not an expression
    int s = A; // Error: type A has no value + stack overflow
}
