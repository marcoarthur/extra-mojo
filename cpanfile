requires 'Mojo::Base';
requires 'Mojo::IOLoop';
requires 'RxPerl::Mojo';
requires 'perl', 'v5.38.0';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Role::Tiny::With';
    requires 'Test2::V0';
    requires 'Test::More', '0.98';
};
