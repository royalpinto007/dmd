// ICE(template.c) in DMD0.080
/*
TEST_OUTPUT:
---
fail_compilation/fail16.d(21): Error: function declaration without return type. (Note that constructors are always named `this`)
  bar!(typeof(X))(X);
                 ^
fail_compilation/fail16.d(21): Error: no identifier for declarator `bar!(typeof(X))(X)`
---
*/

int i;

template bar(T)
{
  void bar(int x) {}
}

template foo(alias X)
{
  bar!(typeof(X))(X);
}


void main()
{
  foo!(i);
}
