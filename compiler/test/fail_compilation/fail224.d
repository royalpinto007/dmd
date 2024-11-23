/*
TEST_OUTPUT:
---
fail_compilation/fail224.d(24): Error: need `this` of type `A` to access member `x` from static function `f`
                    gi = x;
                         ^
---
*/

int gi;

class A
{
    int x = 42;

    void am()
    {
        static void f()
        {
            class B
            {
                void bm()
                {
                    gi = x;
                }
            }

            (new B).bm();
        }

        f();
    }
}

void main()
{
    (new A).am();
}
