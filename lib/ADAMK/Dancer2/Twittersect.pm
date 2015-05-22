package ADAMK::Dancer2::Twittersect;

use 5.14.0;
use strict;
use warnings;
use Params::Util 1.04 ':ALL';
use Dancer2      0.160000;
use ADAMK::Dancer2::Twittersect::Config ();

our $VERSION = '0.01';

sub new {
	my $class = shift;
	my $self  = bless {
		config => _INSTANCE(shift, "ADAMK::Dancer2::Twittersect::Config"),
	}, $class;

	# Validate
	unless ($self->{config}) {
		die "Missing or invalid config object";
	}

	return $self;
}

sub run {
	my $self = shift;

	get '/' => sub {
		return "Hello World";
	};

	dance;
}

1;
