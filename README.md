# NAME

ADAMK::Dancer2::Twittersect - Demonstration web application that finds the
intersection of the twitter followers for two users

# DESCRIPTION

`ADAMK::Dancer2::Twittersect` is a small [Dancer2](https://metacpan.org/pod/Dancer2) demo application that shows
how to avoid the normal Dancer directory structure entirely and embed an entire
application within the module structure, while still retaining a test suite.

This is a great pattern to use for any small or trivial web applications that
allows you to install the application to the system directly using normal CPAN
client tools.

All configuration and view data is embedded in the main module file. It contains
no normal dancer config file, no `environment` directories, no `public`
directory and no `views` directory.

## INSTALLATION

This application can be installed and run on any operating system.

First, you will need to install [Net::Twitter](https://metacpan.org/pod/Net::Twitter) via `cpan` (as it does not have
a legal version number according to `cpanm`

    cpan Net::Twitter

Next, from the command line or unix shell, install the distribution from the
tarball to the system directly from Github using `cpanm`

    cpanm https://github.com/adamkennedy/ADAMK-Dancer2-Twittersect/archive/master.zip

Next, create an security configuration file named `twittersect.conf` containing
a valid Twitter application API key and secret in YAML format like as follows.

    ---
    consumer_api: 123456789abcdefghijklmnop
    consumer_secret: 123456789abcdefghijklmnop123456789abcdefghijklmnop

Finally, launch the `twittersect` application from the directory containing
the configuration file. A message similar to the below should appear indicating
the application has successfully started up.

    twittersect
    >> Dancer2 v0.160001 server 7204 listening on http://0.0.0.0:3000

# AUTHOR

Adam Kennedy <adamk@cpan.org>

# COPYRIGHT

Copyright 2015 Adam Kennedy.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.
