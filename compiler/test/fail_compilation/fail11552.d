/*
REQUIRED_ARGS: -o-
TEST_OUTPUT:
---
fail_compilation/fail11552.d(13): Error: function `D main` label `label` is undefined
    goto label;
    ^
---
*/

void main()
{
    goto label;
}
