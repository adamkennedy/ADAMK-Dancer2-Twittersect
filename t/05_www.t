#!/usr/bin/perl

use strict;
use warnings;
use ADAMK::Dancer2::Twittersect;
use Test::More 1.001013 tests => 2;
use File::Spec 0.80 ();
use Plack::Test;
use HTTP::Request::Common;

my $test = Plack::Test->create(
     ADAMK::Dancer2::Twittersect->to_app
);

subtest 'Default page' => sub {
     my $response = $test->request( GET '/' );
     ok( $response->is_success, '[GET /] Successful request' );
     ok( $response->content =~ /This Dancer2 application takes two twitter screen names/, '[GET /] Correct content' );
};

subtest 'Run a query' => sub {
     my $request  = POST '/', [
          name1 => 'adam_at_alias',
          name2 => 'geo2gov',
     ];
     my $response = $test->request($request);
     ok( $response->is_success, '[POST /] Successful request' );
     ok( $response->content =~ /This Dancer2 application takes two twitter screen names/, '[POST /] Correct content' );
     ok( $response->content =~ /Common Followers/, "[POST /] Common Followers" );
};
