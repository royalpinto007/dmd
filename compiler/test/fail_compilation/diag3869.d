/*
TEST_OUTPUT:
---
fail_compilation/diag3869.d(12): Error: template instance `diag3869.sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!(sum!int))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))` recursive expansion
    auto blah(int a) { return .sum!(sum)(); }
                              ^
---
*/

struct sum(A)
{
    auto blah(int a) { return .sum!(sum)(); }
}

sum!(int) z;
