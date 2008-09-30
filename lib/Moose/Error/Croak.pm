package Moose::Error::Croak;

use strict;
use warnings;

use base qw(Moose::Error::Default);

sub new {
    my ( $self, @args ) = @_;
    $self->create_error_croak(@args);
}

__PACKAGE__

__END__

=pod

=head1 NAME

Moose::Error::Croak - Prefer C<croak>

=head1 SYNOPSIS

	use metaclass => (
        metaclass => "Moose::Meta::Class",
        error_class => "Moose::Error::Croak",
    );

=head1 DESCRIPTION

This error class uses L<Carp/croak> to raise errors generated in your
metaclass.

=head1 METHODS

=over 4

=item new

Overrides L<Moose::Error::Default/new> to prefer C<croak>.

=back

=cut

