/*
TEST_OUTPUT:
---
fail_compilation/fail19912c.d(9): Error: alias `fail19912c.object` conflicts with import `fail19912c.object` at fail_compilation/fail19912c.d
alias object = int;
^
---
*/
alias object = int;
void fun(string) { }
