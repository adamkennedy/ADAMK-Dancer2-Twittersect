#!/usr/bin/perl

use strict;
use warnings;
use Test::More 1.001013 tests => 3;
use File::Spec 0.80 ();
use Params::Util ':ALL';

use ADAMK::Dancer2::Twittersect;

my $config = File::Spec->catfile("twittersect.conf");
ok(-f $config, "Found config file $config");

my $twitter = ADAMK::Dancer2::Twittersect->new($config);
isa_ok($twitter, "ADAMK::Dancer2::Twittersect");

my $users = $twitter->get_intersected_followers("adam_at_alias", "geo2gov");
ok(_ARRAY0($users), "->intersect_followers returns an array ref");
