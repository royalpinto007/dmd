/*
TEST_OUTPUT:
---
fail_compilation/mangle1.d(10): Error: pragma `mangle` can only apply to a single declaration
pragma(mangle, "_stuff_") __gshared { int x, y; }
^
---
*/

pragma(mangle, "_stuff_") __gshared { int x, y; }
