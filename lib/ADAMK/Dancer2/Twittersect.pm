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

# Embed configuration in the application
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
	template index_tt(), {};
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

	template index_tt(), \%vars;
};

# Embed templating in the application
use constant index_tt => \<<END_TEMPLATE;
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Twittersect</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
  </head>

  <style type="text/css">
    p img {
      margin-right: 0.2em;
      height: 24px;
      width: 24px;
      vertical-align: bottom;
    }

    a:hover {
      text-decoration: none;
    }

    a:active {
      text-decoration: none;
    }
  </style>

  <body>
    <div class="jumbotron">
      <div class="container">
        <h1>Twittersect</h1>
        <p>This Dancer2 application takes two twitter screen names and finds the intersection of their followers</p>
      </div>
    </div>

  <div class="container">
  <form class="form-horizontal" method="POST">
    [% IF error %]
    <div class="alert alert-danger" role="alert">
      <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
      <span class="sr-only">Error:</span>
      <span style="white-space: pre-wrap">[% error %]</span>
    </div>
    [% END %]

    <div class="form-group[% IF user1 %] has-success[% END %]">
        <label for="name1" class="control-label col-xs-2">Twitter Name 1</label>
        <div class="col-xs-10">
            <p>
              <input type="text" class="form-control[% IF user1 %] .has-success[% END %]" id="name1" name="name1"[% IF user1 %] value="[% user1.screen_name %]"[% END %] placeholder="screenname">
            </p>
            [% IF user1 %]
              <p>
                <img src="[% user1.profile_image_url %]">
                <b><a href="https://twitter.com/intent/user?user_id=[% user1.id_str %]">[% user1.screen_name %]</a></b>
                <br/>
                Followers: [% user1.followers_count %]
              </p>
            [% END %]
        </div>
    </div>

    <div class="form-group[% IF user2 %] has-success[% END %]">
        <label for="name2" class="control-label col-xs-2">Twitter Name 2</label>
        <div class="col-xs-10">
            <p>
              <input type="text" class="form-control" id="name2" name="name2"[% IF user2 %] value="[% user2.screen_name %]"[% END %] placeholder="screenname">
            </p>
            [% IF user2 %]
              <p>
                <img src="[% user2.profile_image_url %]">
                <b><a href="https://twitter.com/intent/user?user_id=[% user2.id_str %]">[% user2.screen_name %]</a></b>
                <br/>
                Followers: [% user2.followers_count %]
              </p>
            [% END %]
        </div>
    </div>

    <div class="form-group">
        <div class="col-xs-offset-2 col-xs-10">
            <button type="submit" class="btn btn-primary">Find Common Followers</button>
        </div>
    </div>
  </form>
  </div>

  [% IF intersect %]
    <hr>
    <div class="container">
      [% IF intersect_count %]
        <h2>Common Followers: [% intersect_count %]</h2>
        <p>
          [% FOREACH user IN intersect %]
            <img src="[% user.profile_image_url %]">
            <a href="https://twitter.com/intent/user?user_id=[% user.id_str %]">[% user.screen_name %]</a>
            <br/>
          [% END %]
        </p>
      [% ELSE %]
        <h2>No Common Followers</h2>
      [% END %]
    </div>
  [% END %]

  </body>
</html>
END_TEMPLATE

true;

=pod

=head1 NAME

ADAMK::Dancer2::Twittersect - Web application to intersect twitter followers for two users

=head1 DESCRIPTION

C<ADAMK::Dancer2::Twittersect is a small Dancer2 demo application that sheds a number
of normal Dancer elements in the interest of being very very small.

It contains no C<environment> directories, no C<public> directories, a single view
and a single custom config file for security data with all the typical configuration
inlined into the application.



=head1 