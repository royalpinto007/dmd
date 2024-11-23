// https://issues.dlang.org/show_bug.cgi?id=22668

// Overrides with same deprecated'ness are allowed

class SameParent
{
    deprecated void foo() {}
    void foo(int) {}

    void bar(int) {}
    deprecated void bar() {}
}

class SameChild : SameParent
{
    deprecated override void foo() {}
    override void foo(int) {}

    override void bar(int) {}
    deprecated override void bar() {}
}

/**
Only the parent declaration is deprecated

TEST_OUTPUT:
----
compilable/deprecated_override.d(54): Deprecation: `deprecated_override.IntroducingChild.foo` is overriding the deprecated method `deprecated_override.IntroducingParent.foo`
    override void foo() {}
                  ^
compilable/deprecated_override.d(58): Deprecation: `deprecated_override.IntroducingChild.bar` is overriding the deprecated method `deprecated_override.IntroducingParent.bar`
    override void bar() {}
                  ^
compilable/deprecated_override.d(85): Deprecation: `deprecated_override.OverrideChild.foo` cannot be marked as `deprecated` because it is overriding a function in the base class
    deprecated override void foo() {}
                             ^
compilable/deprecated_override.d(89): Deprecation: `deprecated_override.OverrideChild.bar` cannot be marked as `deprecated` because it is overriding a function in the base class
    deprecated override void bar() {}
                             ^
----
**/

class IntroducingParent
{
    deprecated void foo() {}
    void foo(int) {}

    void bar(int) {}
    deprecated void bar() {}
}

class IntroducingChild : IntroducingParent
{
    override void foo() {}
    override void foo(int) {}

    override void bar(int) {}
    override void bar() {}
}

// Unrelated to this path but should this error as well?

class IntroducingGrandchild : IntroducingChild
{
    override void foo() {}
    override void foo(int) {}

    override void bar(int) {}
    override void bar() {}
}

// Only the overriding declaration is deprecated

class OverrideParent
{
    void foo() {}
    void foo(int) {}

    void bar(int) {}
    void bar() {}
}

class OverrideChild : OverrideParent
{
    deprecated override void foo() {}
    override void foo(int) {}

    override void bar(int) {}
    deprecated override void bar() {}
}

class OverrideGrandChild : OverrideChild
{
    deprecated override void foo() {}
    override void foo(int) {}

    override void bar(int) {}
    deprecated override void bar() {}
}
