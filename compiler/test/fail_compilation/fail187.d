// REQUIRED_ARGS: -d
/*
TEST_OUTPUT:
---
fail_compilation/fail187.d(18): Error: `catch` at fail_compilation/fail187.d(22) hides `catch` at fail_compilation/fail187.d(26)
    try
    ^
---
*/

// On DMD 2.000 bug only with typedef, not alias

alias Exception A;
alias Exception B;

void main()
{
    try
    {
        throw new A("test");
    }
    catch (B)
    {
        // this shouldn't happen, but does
    }
    catch (A)
    {
        // this ought to happen?
    }
}
