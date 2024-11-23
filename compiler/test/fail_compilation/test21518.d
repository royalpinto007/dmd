/*
https://issues.dlang.org/show_bug.cgi?id=21518
TEST_OUTPUT:
---
fail_compilation/test21518.d(29): Error: cannot implicitly convert expression `[dg]` of type `const(void delegate() pure nothrow @nogc @system)[]` to `void delegate() @safe[]`
	void delegate() @safe[] arg2 = [ dg ];
                                ^
fail_compilation/test21518.d(33): Error: cannot implicitly convert expression `[dg]` of type `const(void delegate() pure nothrow @nogc @system)[]` to `const(void delegate() @safe)[]`
	const(void delegate() @safe)[] arg = [ dg ];
                                      ^
fail_compilation/test21518.d(38): Error: cannot implicitly convert expression `sysA` of type `const(void delegate() @system)[]` to `const(void delegate() @safe)[]`
	const(void delegate() @safe)[] safeA = sysA;
                                        ^
fail_compilation/test21518.d(41): Error: cannot implicitly convert expression `sysA` of type `const(void delegate() @system)[]` to `const(void delegate() @safe)`
	func(sysA);
      ^
fail_compilation/test21518.d(42): Error: cannot implicitly convert expression `dg` of type `const(void delegate() pure nothrow @nogc @system)` to `const(void delegate() @safe)`
	func(dg);
      ^
---
*/

void delegates()
{
	const dg = delegate() @system { int* p; int x; p = &x; };
	// pragma(msg, typeof(dg)); // const(void delegate() pure nothrow @nogc @system)

	// Correctly fails
	void delegate() @safe[] arg2 = [ dg ];
	void delegate() @system[] arg3 = [ dg ]; // But doesnt break this

	// Previously ignored
	const(void delegate() @safe)[] arg = [ dg ];
	// pragma(msg, typeof(arg)); // const(void delegate() @safe)[]

	// Also for variables, not only array literals
	const(void delegate() @system)[] sysA = [ dg ];
	const(void delegate() @safe)[] safeA = sysA;

	// Original bug report:
	func(sysA);
	func(dg);
}

void func(const void delegate() @safe [] paramDGs...) @safe
{
	if (paramDGs.length > 0) paramDGs[0]();
}
