/* REQUIRED_ARGS: -preview=dip1000
 * TEST_OUTPUT:
---
fail_compilation/fail17927.d(21): Error: scope parameter `this` may not be returned
    const(char)* mem1() const scope @safe { return ptr; }
                                                   ^
fail_compilation/fail17927.d(23): Error: scope parameter `this` may not be returned
    inout(char)* mem2() inout scope @safe { return ptr; }
                                                   ^
fail_compilation/fail17927.d(29): Error: scope parameter `ptr` may not be returned
const(char)* foo1(scope const(char)* ptr) @safe { return ptr; }
                                                         ^
fail_compilation/fail17927.d(31): Error: scope parameter `ptr` may not be returned
inout(char)* foo2(scope inout(char)* ptr) @safe { return ptr; }
                                                         ^
---
*/
// https://issues.dlang.org/show_bug.cgi?id=17927

struct String {
    const(char)* mem1() const scope @safe { return ptr; }
    // https://issues.dlang.org/show_bug.cgi?id=22027
    inout(char)* mem2() inout scope @safe { return ptr; }

    char* ptr;
}


const(char)* foo1(scope const(char)* ptr) @safe { return ptr; }

inout(char)* foo2(scope inout(char)* ptr) @safe { return ptr; }
