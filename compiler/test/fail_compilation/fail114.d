/*
TEST_OUTPUT:
---
fail_compilation/fail114.d(14): Error: forward reference to `funcA`
void funcB(typeof(&funcA) p) {}
     ^
---
*/

// https://issues.dlang.org/show_bug.cgi?id=371
// ICE on mutual recursive typeof in function declarations
void funcA(typeof(&funcB) p) {}

void funcB(typeof(&funcA) p) {}
