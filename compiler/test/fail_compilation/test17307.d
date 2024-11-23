/*
TEST_OUTPUT:
---
fail_compilation/test17307.d(11): Error: anonymous struct can only be a part of an aggregate, not module `test17307`
struct { enum bitsPerWord = size_t; }
^
---
 * https://issues.dlang.org/show_bug.cgi?id=17307
 */

struct { enum bitsPerWord = size_t; }

void main()
{ }
