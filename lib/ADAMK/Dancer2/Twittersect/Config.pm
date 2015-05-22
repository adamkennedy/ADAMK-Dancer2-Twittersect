package ADAMK::Dancer2::Twittersect::Config;

use strict;
use warnings;
use YAML::Tiny   1.50 ();
use Params::Util 1.04 ':ALL';
use Object::Tiny 1.08 qw{
	consumer_api
	consumer_secret
	access_token
	access_secret
};

our $VERSION = '0.01';

sub new {
	my $class = shift;
	my $file  = shift;

	# Is the config even roughly correct
	my $yaml  = YAML::Tiny->read($file);
	unless ($yaml->[0] and _HASH($yaml->[0]->{keys})) {
		die "Config file does not have a keys section";
	}

	my $self = $class->SUPER::new(
		%{$yaml->[0]->{keys}}
	);

	# Validate
	unless ($self->consumer_api) {
		die "Config file does not provide a consumer_api";
	}
	unless ($self->consumer_secret) {
		die "Config file does not provide a consumer_secret";
	}
	unless ($self->access_token) {
		die "Config file does not provide an access_token";
	}
	unless ($self->access_secret) {
		die "Config filer does not provide an access_secret";
	}

	return $self;
}

1;
