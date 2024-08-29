use strict;
use warnings;
use Test2::V0;
use Mojo::IOLoop;
use v5.38;

package My::Class {
    use Mojo::Base -base;
    use Role::Tiny::With;
    with qw/Mojo::Role::Retry/;
}

my $obj = My::Class->new;

$obj->code_retry(sub { return 'Finished' })
->subscribe( 
    sub ($x){ is $x, 'Finished', 'ok succeed' }
);

$obj->code_retry(sub { die "Error" })
->subscribe(
    {
        next => sub { fail "Cannot succeed" },
        error => sub { ok 1, "ok failed" },
        complete => sub { ok 1, "completed" },
    }
);

SKIP: {
    skip "Count the failed attempts, needs ipc";
    my $count = 0;

    $obj->code_retry(
        sub { 
            die "busted" if $count++ < 2;
            return "got it";
        }
    )->subscribe(
        { 
            next => sub ($x){ is $x, "got it", "recovered" },
            error => sub { fail "Cannot fail" },
            complete => sub { ok 1, "should complete" },
        }
    );

}

Mojo::IOLoop->start unless Mojo::IOLoop->is_running;
done_testing;
