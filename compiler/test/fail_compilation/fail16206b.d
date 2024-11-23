/*
TEST_OUTPUT:
---
fail_compilation/fail16206b.d(16): Error: expected 2 arguments for `hasMember` but had 3
alias allFoos = AliasSeq!(__traits(hasMember, S, "foo", true));
                          ^
---
*/

struct S
{
    static int foo()() { return 0; }
}

alias AliasSeq(T...) = T;
alias allFoos = AliasSeq!(__traits(hasMember, S, "foo", true));
