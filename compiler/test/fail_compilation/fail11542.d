// REQUIRED_ARGS: -o-

/*
TEST_OUTPUT:
---
fail_compilation/fail11542.d(35): Error: `object.Exception` is thrown but not caught
    throw new Exception("");    // error
    ^
fail_compilation/fail11542.d(32): Error: function `fail11542.test_success1` may throw but is marked as `nothrow`
void test_success1() nothrow
     ^
fail_compilation/fail11542.d(45): Error: `object.Exception` is thrown but not caught
    throw new Exception("");    // error
    ^
fail_compilation/fail11542.d(42): Error: function `fail11542.test_success3` may throw but is marked as `nothrow`
void test_success3() nothrow
     ^
fail_compilation/fail11542.d(51): Error: `object.Exception` is thrown but not caught
    throw new Exception("");    // error
    ^
fail_compilation/fail11542.d(48): Error: function `fail11542.test_failure1` may throw but is marked as `nothrow`
void test_failure1() nothrow
     ^
fail_compilation/fail11542.d(67): Error: `object.Exception` is thrown but not caught
    throw new Exception("");    // error
    ^
fail_compilation/fail11542.d(64): Error: function `fail11542.test_exit1` may throw but is marked as `nothrow`
void test_exit1() nothrow
     ^
---
*/
void test_success1() nothrow
{
    scope(success) {}
    throw new Exception("");    // error
}
void test_success2() nothrow
{
    scope(success) {}
    throw new Error("");        // no error
}
void test_success3() nothrow
{
    scope(success) assert(0);
    throw new Exception("");    // error
}

void test_failure1() nothrow
{
    scope(failure) {}
    throw new Exception("");    // error
}
void test_failure2() nothrow
{
    scope(failure) {}
    throw new Error("");        // no error
}
void est_failure3() nothrow
{
    scope(failure) assert(0);
    throw new Exception("");    // no error
}

void test_exit1() nothrow
{
    scope(exit) {}
    throw new Exception("");    // error
}
void test_exit2() nothrow
{
    scope(exit) {}
    throw new Error("");        // no error
}
void test_exit3() nothrow
{
    scope(exit) assert(0);
    throw new Exception("");    // no error
}
