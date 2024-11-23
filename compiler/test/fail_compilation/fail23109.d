// https://issues.dlang.org/show_bug.cgi?id=23109
/*
EXTRA_FILES: imports/test23109a.d imports/test23109b.d imports/test23109c.d
EXTRA_SOURCES: extra-files/test23109/object.d
TEST_OUTPUT:
---
Error: no property `getHash` for `typeid(const(Ensure[]))` of type `object.TypeInfo_Const`
fail_compilation/extra-files/test23109/object.d(7):        class `TypeInfo_Const` defined here
class TypeInfo_Const {}
^
Error: no property `getHash` for `typeid(const(Ensure[1]))` of type `object.TypeInfo_Const`
fail_compilation/extra-files/test23109/object.d(7):        class `TypeInfo_Const` defined here
class TypeInfo_Const {}
^
fail_compilation/imports/test23109a.d(10): Error: template instance `imports.test23109a.Array!(Ensure)` error instantiating
alias Ensures = Array!Ensure;
                ^
---
*/
import imports.test23109a;
