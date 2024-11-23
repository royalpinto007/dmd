/*
TEST_OUTPUT:
---
fail_compilation/ice10938.d(18): Error: no property `opts` for `this` of type `ice10938.C`
        this.opts["opts"] = 1;
            ^
fail_compilation/ice10938.d(18):        potentially malformed `opDispatch`. Use an explicit instantiation to get a better error message
fail_compilation/ice10938.d(14):        class `C` defined here
class C
^
---
*/

class C
{
    this()
    {
        this.opts["opts"] = 1;
    }

    auto opDispatch(string field : "opts")()
    {
        return this.opts;  // ICE -> compile time error
    }
}

void main()
{
}
