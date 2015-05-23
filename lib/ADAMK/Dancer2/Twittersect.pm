package ADAMK::Dancer2::Twittersect;

use 5.14.0;
use strict;
use warnings;
use Try::Tiny    0.22;
use YAML::Tiny   1.50 ();
use Params::Util 1.04 ':ALL';
use Net::Twitter 4.01010 ();
use Dancer2      0.160000;

use ADAMK::Dancer2::Twittersect::Twitter;
use ADAMK::Dancer2::Twittersect::Exception;

our $VERSION = '0.01';

set 'show_errors'  => 1;
set 'startup_info' => 1;
set 'warnings'     => 1;
set 'logger'       => 'console';
set 'log'          => 'debug';
set 'template'     => 'tiny';

my $twitter = ADAMK::Dancer2::Twittersect::Twitter->new("twittersect.conf");

# Convenience function
sub throw ($) {
	ADAMK::Dancer2::Twittersect::Exception->throw(shift);
}

# Params::Util style validator function
sub _SCREENNAME {
	(defined $_[0] and $_[0] =~ /[a-zA-Z0-9_]{1,15}/) ? $_[0] : undef;
}

get '/' => sub {
	template "index", {};
};

post '/' => sub {
	my %vars = ();
	try {
		# Lookup the users
		$vars{name1} = _SCREENNAME(params->{name1});
		$vars{name2} = _SCREENNAME(params->{name2});
		if ($vars{name1}) {
			$vars{user1} = $twitter->get_user_by_name($vars{name1});
		}
		if ($vars{name2}) {
			$vars{user2} = $twitter->get_user_by_name($vars{name2});
		}

		# User related errors before we intersect
		unless ($vars{name1}) {
			throw "First twitter name missing or invalid";
		}
		unless ($vars{name2}) {
			throw "Second twitter name missing or invalid";
		}
		unless ($vars{user1}) {
			throw "First twitter user ($vars{name1}) does not exist";
		}
		unless ($vars{user2}) {
			throw "Second twitter user ($vars{name2}) does not exist";
		}

		# Find the user intersection
		$vars{intersect} = $twitter->get_intersected_followers($vars{name1}, $vars{name2});
		$vars{intersect_count} = scalar @{$vars{intersect}};

	} catch {
		# Enhance various errors
		if (_INSTANCE($_, "ADAMK::Dancer2::Twittersect::Exception")) {
			$vars{error} = $_->message;

		} elsif (_INSTANCE($_, "Net::Twitter::Error")) {
			$vars{error} = "Twitter API Error:\n"
				. "HTTP Response Code: " . $_->code . "\n"
				. "HTTP Message......: " . $_->message . "\n"
				. "Twitter error.....: " . $_->error . "\n";

		} else {
			$vars{error} = "Unmanaged Error:\n$_";
		}
	};

	template "index", \%vars;
};

true;
