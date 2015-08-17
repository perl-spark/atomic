use v5.14;
use strict;
use warnings;

package atomic;

use Try::Tiny;

require Exporter;
our @EXPORT = qw(compare_and_swap swap);
our @ISA = qw(Exporter);

require XSLoader;
our $VERSION = "0";

XSLoader::load('atomic', $VERSION);

# Exporter doesn't work properly with XSUBS
sub compare_and_swap { _compare_and_swap(@_); }
sub swap (&$) { _swap(@_); }

1;
__END__

=head1 atomic

Provides a thread-safe `compare_and_swap` primitive using C CAS intrinsics

=head1 SYNOPSIS

    use atomic;

    my $a = \"abc";
    atomic::compare_and_swap($a, $$a, "def");
    is($$a, "def", "Same pointer, so it swaps");
    atomic::compare_and_swap($a, "def", "ghi");
    is($$a, "def", "Not the same pointer, so it doesn't swap");

=head1 EXPORTS

=head2 compare_and_swap($ref, $oldval, $newval) -> Bool

Compares the value referred to by ref against $oldval. If the pointers match, replaces it with $newval.

=head1 GOTCHAS

=head2 XS

This uses C CAS intrinsics and thus requires XS to glue C into perl.

It's possible to provide the same semantics using locks in pure perl but it will be slow!

=head2 POINTERS

Things are considered equal if the pointers match. Identically structured data are not equal.

This is a low-level library and you are expected to understand the implications of this.

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2015 James Laver

Distributed under the same license terms as Perl itself.

=cut
