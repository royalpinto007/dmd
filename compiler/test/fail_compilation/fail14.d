/*
TEST_OUTPUT:
---
fail_compilation/fail14.d(12): Error: template instance `fail14.A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!(A!int))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))` recursive expansion exceeded allowed nesting limit
    .A!(A) x;
     ^
---
*/

class A(T)
{
    .A!(A) x;

}

void main()
{
	A!(int);
}
