/* TEST_OUTPUT:
---
fail_compilation/b15875.d(13): Error: undefined identifier `a`
d o(int[a]a)(){}
    ^
fail_compilation/b15875.d(14): Error: circular reference to `b15875.f`
f.T f(){}
    ^
---
*/
// https://issues.dlang.org/show_bug.cgi?id=15875
// https://issues.dlang.org/show_bug.cgi?id=17290
d o(int[a]a)(){}
f.T f(){}
