/*
TEST_OUTPUT:
---
fail_compilation/fail316.d(19): Error: mixin `fail316.foo.BadImpl!(uint, Mix1)` cannot resolve forward reference
  mixin BadImpl!(uint,Mix1) Mix1;
  ^
---
*/
template BadImpl(T, alias thename)
{
  void a_bad_idea(T t)
  {
    thename.a_bad_idea(t);
  }
}

class foo
{
  mixin BadImpl!(uint,Mix1) Mix1;
}

int main()
{
  return 0;
}
