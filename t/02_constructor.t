#!/usr/bin/perl

use strict;
use warnings;
use Test::More 1.001013 tests => 2;
use File::Spec 0.80 ();

use ADAMK::Dancer2::Twittersect::Twitter;

my $config = File::Spec->catfile("twittersect.conf");
ok(-f $config, "Found config file $config");

my $twitter = ADAMK::Dancer2::Twittersect::Twitter->new($config);
isa_ok($twitter, "ADAMK::Dancer2::Twittersect::Twitter");
