use strict;
use warnings;

use Test::More tests => 2;

use Test::DZil;

my $tzil = Builder->from_config(
    { dist_root => 't/corpus' },
);

$tzil->build;

my @shared = grep { $_->name =~ m#share/# } @{ $tzil->files };

is @shared => 1, "there is only one file";

is $shared[0]->name => 'share/shared-files.tar.gz', "and it's the tarball";
