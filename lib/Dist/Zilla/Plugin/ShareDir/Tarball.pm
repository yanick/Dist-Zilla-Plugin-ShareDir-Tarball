package Dist::Zilla::Plugin::ShareDir::Tarball;
# ABSTRACT: Bundle your shared dir into a tarball

=head1 SYNOPSIS

    # in dist.ini

    [ShareDir::Tarball]

=head1 DESCRIPTION

Using L<File::ShareDir> to deploy non-Perl files alongside a distribution is
great, but it has a problem.  Just like for modules, upon installation CPAN clients
don't remove any of the files that were already present in the I</lib>
directories beforehand. So if version 1.0 of the distribution was sharing

    share/foo
    share/bar

and version 1.1 changed that to 

    share/foo
    share/baz

then a user installing first version 1.0 then 1.1 will end up with 

    share/foo
    share/bar
    share/baz

which might be a problem (or not).

Fortunately, there is a sneaky
workaround in the case where you don't want the files of past distributions to
linger around. The trick is simple: bundle all the files to be shared into
a tarball called I<shared-files.tar.gz>.  As there is only that one file, any
new install is conveniently clobbering the old version. 

But archiving the content of the I<share> directory is no fun. Hence
L<Dist::Zilla::Plugin::ShareDir::Tarball> which, upon the file munging stage, gathers all 
files in the I<share> directory and build the I<shared-files.tar.gz> archive
with them.  If there is no such files, the process is simply skipped.

=head1 OPTIONS

=head2 dir

The source directory to be bundled into the shared tarball. Defaults to
C<share>.

=head1 SEE ALSO

L<Dist::Zilla::Plugin::ShareDir>, which is similar to this module, but without
the conversion of the shared directory into a tarball.

L<File::ShareDir::Tarball> - transparently extract the tarball behind the
scene so that the shared directory can be accessed just like it is in
L<File::ShareDir>.

L<Module::Build::CleanInstall> - A subclass of L<Module::Build> which
deinstall the files from previous installations via their I<packlist>.

=cut

use strict;
use warnings;

use Moose;

use Dist::Zilla::File::InMemory;
use Compress::Zlib;
use Archive::Tar;

has dir => (
  is   => 'ro',
  isa  => 'Str',
  default => 'share',
);

has archive => (
    is => 'ro',
    lazy => 1,
    predicate => 'has_archive',
    default => sub {
        Archive::Tar->new;
    },
);

has share_dir_map => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my $self = shift;
        return {} unless $self->has_archive;

        return { dist => $self->dir };
    },
);

sub compressed_archive { 
    Compress::Zlib::memGzip($_[0]->archive->write) 
}

sub find_files {
  my $self = shift;

  my $dir = $self->dir . '/';
  return grep { !index $_->name, $dir } @{ $self->zilla->files };
}


sub munge_files {
    my( $self ) = @_;

    my $src = $self->dir;
    my @shared = $self->find_files or return;

    for ( @shared ) {
        ( my $archive_name = $_->name ) =~ s#$src/##;
        $self->archive->add_data( $archive_name => $_->content );
        $self->zilla->prune_file($_);
    }

    $self->add_file( Dist::Zilla::File::InMemory->new(
        name    => join( '/', $self->dir, 'shared-files.tar.gz'),
        content => $self->compressed_archive,
    ));
}

with 'Dist::Zilla::Role::ShareDir',
     'Dist::Zilla::Role::FileInjector',
     'Dist::Zilla::Role::FileMunger';

1;
