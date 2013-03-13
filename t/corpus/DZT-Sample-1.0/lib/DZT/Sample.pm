use strict;
use warnings;
package DZT::Sample;
# ABSTRACT: test module

sub return_arrayref_of_values_passed {
  my $invocant = shift;
  return \@_;
}

1;

__END__

=pod

=head1 NAME

DZT::Sample - test module

=head1 VERSION

version 1.0

=head1 AUTHOR

Yanick Champoux <yanick@babyl.dyndns.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Yanick Champoux.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
