/*
REQUIRED_ARGS: -Ifail_compilation/imports/
EXTRA_FILES: imports/import21508.d
TEST_OUTPUT:
---
fail_compilation/fail21508_2.d(13): Error: import `fail21508_2.import21508` is used as a type
class Other : import21508 { }
^
---
*/
import import21508;

class Other : import21508 { }
