// https://issues.dlang.org/show_bug.cgi?id=7524
/*
TEST_OUTPUT:
---
fail_compilation/fail7524b.d(11): Error: invalid filename for `#line` directive
#line 47 __VERSION__
         ^
---
*/

#line 47 __VERSION__
