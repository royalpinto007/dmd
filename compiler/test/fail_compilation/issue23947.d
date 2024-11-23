// https://issues.dlang.org/show_bug.cgi?id=23947
/*
TEST_OUTPUT:
---
fail_compilation/issue23947.d(12): Error: function `imports.issue23947a.Class.handle` of type `void(X x)` is not accessible from module `issue23947`
void main() { Class.init.handle(X.init); }
                               ^
---
*/
import imports.issue23947a;

void main() { Class.init.handle(X.init); }
