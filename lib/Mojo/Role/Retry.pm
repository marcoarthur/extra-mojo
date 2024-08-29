package Mojo::Role::Retry;
use Mojo::Base -strict, -signatures, -role;
use RxPerl::Mojo ':all';
use Mojo::IOLoop;
use Carp qw(croak);

our $VERSION = "0.01";

has retries => sub { 3 };

sub code_retry($self, $code) {
  croak "Need CODE ref" unless $code;
  croak "Not a CODE ref" unless ref $code eq 'CODE';

  my $subprocess__ = rx_of(1)->pipe(
    op_switch_map( 
      sub { rx_from(Mojo::IOLoop->subprocess->run_p($code)) } 
    ),
    op_take(1),
  );

  return $subprocess__->pipe( op_retry($self->retries) );
}

1;
__END__

=encoding utf-8

=head1 NAME

Mojo::Role::Retry - Runs code in subprocess and retry

=head1 SYNOPSIS

  package My::Mojo::Class {
    use Mojo::Base -base;
    use Role::Tiny::With;
    with qw/Mojo::Role::Retry/;
  }

  package main
  use Mojo::IOLoop;
  my $obj = My::Mojo::Class->new;
  $obj->code_retry( sub { sleep 5; return 'Finished' } )
      ->subscribe( sub { say "Subprocess returned: $_[0]" } );
  Mojo::IOLoop->start unless Mojo::IOLoop->is_running;


=head1 DESCRIPTION

Mojo::Role::Retry is role for setting code to run in a child process.
Returning an RxPerl Observable

=head1 LICENSE

Copyright (C) Marco Silva.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Marco Silva E<lt>arthurpbs@gmail.comE<gt>

=cut

