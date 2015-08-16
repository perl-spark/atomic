# atomic

Provides a thread-safe \`compare\_and\_swap\` primitive using C CAS intrinsics

# SYNOPSIS

    use atomic;

    my $a = \"abc";
    atomic::compare_and_swap($a, $$a, "def");
    is($$a, "def", "Same pointer, so it swaps");
    atomic::compare_and_swap($a, "def", "ghi");
    is($$a, "def", "Not the same pointer, so it doesn't swap");

# EXPORTS

## compare\_and\_swap($ref, $oldval, $newval) -> Bool

Compares the value referred to by ref against $oldval. If the pointers match, replaces it with $newval.

# GOTCHAS

## XS

This uses C CAS intrinsics and thus requires XS to glue C into perl.

It's possible to provide the same semantics using locks in pure perl but it will be slow!

## POINTERS

Things are considered equal if the pointers match. Identically structured data are not equal.

This is a low-level library and you are expected to understand the implications of this.

# COPYRIGHT AND LICENSE

Copyright (c) 2015 James Laver

Distributed under the same license terms as Perl itself.
