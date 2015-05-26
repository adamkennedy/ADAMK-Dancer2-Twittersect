package ADAMK::Dancer2::Twittersect::Exception;

use 5.010;
use strict;
use warnings;

use Object::Tiny 1.08 qw{
	message
};

our $VERSION = '0.01';

sub throw {
	die shift->new(message => shift);
}

1;
