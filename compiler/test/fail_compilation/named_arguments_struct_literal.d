/**
TEST_OUTPUT:
---
fail_compilation/named_arguments_struct_literal.d(16): Error: trying to initialize past the last field `z` of `S`
	3,
 ^
---
*/

// https://issues.dlang.org/show_bug.cgi?id=24281

struct S { int y, z = 3; }

S s = S(
	z: 2,
	3,
);
