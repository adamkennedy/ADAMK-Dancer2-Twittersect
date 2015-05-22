package ADAMK::Dancer2::Twittersect;

use 5.14.0;
use strict;
use warnings;
use Dancer2;

our $VERSION = '0.01';

sub new {
	my $class = shift;
	my $self  = bless {
		config => _INSTANCE(shift, "Config::Tiny"),
	}, $class;

	# Validate
	unless ($self->{config}) {
		die "Missing or invalid config object";
	}

	return $self;
}

sub run {
	my $class = shift;

	get '/' => sub {
		return "Hello World";
	};

	dance;
}

1;
