/*
TEST_OUTPUT:
---
fail_compilation/e15876_3.d(34): Error: unexpected `(` in declarator
d(={for
 ^
fail_compilation/e15876_3.d(34): Error: basic type expected, not `=`
d(={for
  ^
fail_compilation/e15876_3.d(35): Error: found `End of File` when expecting `(`
fail_compilation/e15876_3.d(35): Error: found `End of File` instead of statement
fail_compilation/e15876_3.d(35): Error: expression expected, not `End of File`
fail_compilation/e15876_3.d(35): Error: found `End of File` when expecting `;` following `for` condition
fail_compilation/e15876_3.d(35): Error: expression expected, not `End of File`
fail_compilation/e15876_3.d(35): Error: found `End of File` when expecting `)`
fail_compilation/e15876_3.d(35): Error: found `End of File` instead of statement
fail_compilation/e15876_3.d(35): Error: matching `}` expected following compound statement, not `End of File`
fail_compilation/e15876_3.d(34):        unmatched `{`
d(={for
   ^
fail_compilation/e15876_3.d(35): Error: found `End of File` when expecting `)`
fail_compilation/e15876_3.d(35): Error: no identifier for declarator `d(_error_ = ()
{
for (__error__
 __error; __error)
{
__error__
}
}
)`
fail_compilation/e15876_3.d(35): Error: semicolon expected following function declaration, not `End of File`
---
*/
d(={for
