/*
TEST_OUTPUT:
---
fail_compilation/ice13385.d(11): Error: visibility attribute `package(a)` does not bind to one of ancestor packages of module `ice13385`
package(a) void foo() {}
^
---
*/
module ice13385;

package(a) void foo() {}
