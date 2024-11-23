/*
REQUIRED_ARGS: -preview=systemVariables
TEST_OUTPUT:
---
fail_compilation/systemvariables_struct.d(51): Error: cannot access `@system` field `S.syst` in `@safe` code
    s0.syst = null;
    ^
fail_compilation/systemvariables_struct.d(52): Error: cannot access `@system` field `S.syst` in `@safe` code
    __traits(getMember, s0, "syst") = null;
    ^
fail_compilation/systemvariables_struct.d(53): Error: cannot access `@system` field `S.syst` in `@safe` code
    s0.tupleof[0] = null;
    ^
fail_compilation/systemvariables_struct.d(56): Error: cannot access `@system` field `S.syst` in `@safe` code
    auto a0 = s0.syst;
              ^
fail_compilation/systemvariables_struct.d(57): Error: cannot access `@system` field `S.syst` in `@safe` code
    auto a1 = __traits(getMember, s0, "syst");
              ^
fail_compilation/systemvariables_struct.d(58): Error: cannot access `@system` field `S.syst` in `@safe` code
    auto a2 = s0.tupleof[0];
              ^
fail_compilation/systemvariables_struct.d(74): Error: cannot access `@system` field `S2.syst` in `@safe` code
    gs2.syst.syst = null;
    ^
fail_compilation/systemvariables_struct.d(75): Error: cannot access `@system` field `S2.syst` in `@safe` code
    gs2.syst.safe = null;
    ^
fail_compilation/systemvariables_struct.d(76): Error: cannot access `@system` field `S.syst` in `@safe` code
    gs2.safe.syst = null;
    ^
fail_compilation/systemvariables_struct.d(77): Error: cannot access `@system` field `S.syst` in `@safe` code
    gs2.safe.syst.safe = null;
    ^
---
*/

// http://dlang.org/dips/1035

struct S
{
    @system S* syst;
    @safe S* safe;
}

void aggregate() @safe
{
    S s0;

    // write access
    s0.syst = null;
    __traits(getMember, s0, "syst") = null;
    s0.tupleof[0] = null;

    // read access
    auto a0 = s0.syst;
    auto a1 = __traits(getMember, s0, "syst");
    auto a2 = s0.tupleof[0];

    S s1;
    s1 = s0; // allowed
}

struct S2
{
    @system S syst;
    @safe   S safe;
}

@safe S2 gs2;

void aggregate2() @safe
{
    gs2.syst.syst = null;
    gs2.syst.safe = null;
    gs2.safe.syst = null;
    gs2.safe.syst.safe = null;

    gs2.safe.safe = null; // allowed
}
