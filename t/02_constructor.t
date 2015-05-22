#!/usr/bin/perl

use strict;
use warnings;
use Test::More 1.001013 tests => 3;
use ADAMK::Dancer2::Twittersect;

my $conf = File::Spec->catfile("t", "02_constructor.conf");
ok(-f $conf, "Found config file");

my $config = ADAMK::Dancer2::Twittersect::Config->new($conf);
isa_ok($config, "ADAMK::Dancer2::Twittersect::Config");

my $server = ADAMK::Dancer2::Twittersect->new($config);
isa_ok($server, "ADAMK::Dancer2::Twittersect");
