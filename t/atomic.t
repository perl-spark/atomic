use Test::More;

use atomic;

my $a = \"abc";
atomic::compare_and_swap($a, $$a, "def");
is($$a, "def", "Same pointer, so it swaps");
atomic::compare_and_swap($a, "def", "ghi");
is($$a, "def", "Not the same pointer, so it doesn't swap");
# swap { (shift) x 2 } $a;
# is($$a, "defdef");

done_testing;
