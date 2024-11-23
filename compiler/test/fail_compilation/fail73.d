/*
TEST_OUTPUT:
---
fail_compilation/fail73.d(22): Error: `case` not in `switch` statement
                case 2:
                ^
---
*/

// segfault DMD 0.120
// https://www.digitalmars.com/d/archives/digitalmars/D/bugs/4634.html

void main()
{
    int u=2;

    switch(u)
    {
        case 1:
            void j()
            {
                case 2:
                    u++;
            }
            break;

        default:
            break;
    }
}
