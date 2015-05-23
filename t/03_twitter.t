#!/usr/bin/perl

use strict;
use warnings;
use Test::More 1.001013 tests => 6;
use File::Spec 0.80 ();
use Params::Util 1.04 ':ALL';

use ADAMK::Dancer2::Twittersect;

my $config = File::Spec->catfile("twittersect.conf");
ok(-f $config, "Found config file $config");

my $twitter = ADAMK::Dancer2::Twittersect->new($config);
isa_ok($twitter, "ADAMK::Dancer2::Twittersect");

my $user = $twitter->get_user_by_name("adam_at_alias");
ok(_HASH($user), "Found user information");

my $followers = $twitter->get_followers_by_id("adam_at_alias");
ok(_ARRAY($followers), "Found follower information");

my $users = $twitter->get_users_by_id($followers);
ok(_ARRAY($users), "Found user information");

is(scalar(@$followers), scalar(@$users), "All users exist");
