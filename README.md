[![Actions Status](https://github.com/marcoarthur/extra-mojo/actions/workflows/test.yml/badge.svg)](https://github.com/marcoarthur/extra-mojo/actions)
# NAME

Mojo::Role::Retry - Runs code in subprocess and retry

# SYNOPSIS

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

# DESCRIPTION

Mojo::Role::Retry is role for setting code to run in a child process.
Returning an RxPerl Observable

# LICENSE

Copyright (C) Marco Silva.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Marco Silva <arthurpbs@gmail.com>
