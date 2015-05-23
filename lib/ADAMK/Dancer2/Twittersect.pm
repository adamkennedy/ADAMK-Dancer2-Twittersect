package ADAMK::Dancer2::Twittersect;

use strict;
use warnings;
use YAML::Tiny   1.50 ();
use Params::Util 1.04 ':ALL';
use Net::Twitter 4.01010 ();

use Object::Tiny 1.08 qw{
	consumer_api
	consumer_secret
	access_token
	twitter
};

our $VERSION = '0.01';

sub new {
	my $class = shift;
	my $file  = shift;

	# Is the config even roughly correct
	my $yaml  = YAML::Tiny->read($file);
	unless ($yaml->[0] and _HASH($yaml->[0])) {
		die "Config file does not have keys";
	}

	my $self = $class->SUPER::new(
		%{$yaml->[0]}
	);

	# Validate
	unless ($self->consumer_api) {
		die "Config file does not provide a consumer_api";
	}
	unless ($self->consumer_secret) {
		die "Config file does not provide a consumer_secret";
	}

	# Create the twitter connector
	$self->{twitter} = Net::Twitter->new(
		traits              => ["API::RESTv1_1", "AppAuth"],
		consumer_key        => $self->consumer_api,
		consumer_secret     => $self->consumer_secret,
	);

	# Get the Application-Only access token
	$self->{access_token} = $self->twitter->request_access_token;

	return $self;
}

sub get_intersected_followers {
	my $self  = shift;
	my $name1 = shift;
	my $name2 = shift;

	# Get the followers
	my $followers1 = $self->get_followers_by_id($name1);
	my $followers2 = $self->get_followers_by_id($name2);

	# Find the intersection
	my %filter    = map  { $_ => 1     } @$followers1;
	my @intersect = grep { $filter{$_} } @$followers1;

	# Get the user information
	return $self->get_users_by_id(@intersect);
}





######################################################################
# Twitter Wrapper Methods

sub get_user_by_name {
	my $self = shift;
	my $name = shift;

	my $result = eval {
		$self->twitter->lookup_users({ screen_name => [ $name ] })->[0];
	};
	if ($@) {
		if (_INSTANCE($@, "Net::Twitter::Error") and $@->error =~ /No user matches for specified terms/) {
			$result = undef;
		} else {
			die $@;
		}
	}

	return $result;
}

sub get_users_by_id {
	my $self = shift;
	my $ids  = shift;
	return $self->twitter->lookup_users({ user_id => $ids });
}

sub get_followers_by_id {
	my $self = shift;
	my $name = shift;

	my $result = $self->twitter->followers_ids({
		screen_name => $name,
		cursor      => -1,
	});

	if ($result->{next_cursor} or $result->{previous_cursor}) {
		throw ADAMK::Dancer2::Twittersect::Exception "This application only supports Twitter users with less than 5000 followers (to prevent hitting rate limits)";
	}

	return $result->{ids};
}





######################################################################
# Simple Exception Object

package ADAMK::Dancer2::Twittersect::Exception;

use Object::Tiny 1.08 qw{
	message
};

sub throw {
	die shift->new(message => shift);
}

1;
