/*
TEST_OUTPUT:
---
fail_compilation/fail6611.d(13): Error: cannot post-increment array slice `x[]`, use pre-increment instead
    x[]++;
       ^
---
*/

void main()
{
    auto x = new int[](10);
    x[]++;
}
