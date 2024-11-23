/*
TEST_OUTPUT:
---
fail_compilation/bug8891.d(23): Error: calling non-static function `opCall` requires an instance of type `S`
    S s = 10;
      ^
---
*/

struct S
{
    int value = 10;
    S opCall(int n) // non-static
    {
        //printf("this.value = %d\n", this.value);    // prints garbage!
        S s;
        s.value = n;
        return s;
    }
}
void main()
{
    S s = 10;
}
