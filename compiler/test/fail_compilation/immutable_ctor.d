/*
TEST_OUTPUT:
---
fail_compilation/immutable_ctor.d(20): Error: `immutable` copy constructor `immutable_ctor.S1.this` cannot construct a mutable object
    S1 ms1 = s1;
       ^
---
*/

struct S1
{
    this(ref const S1 s) immutable {
    }
    int i;
}

void main()
{
    const(S1) s1;
    S1 ms1 = s1;
}
