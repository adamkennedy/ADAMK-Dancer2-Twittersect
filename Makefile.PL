use inc::Module::Install::DSL 1.06;

repository     https://github.com/adamkennedy/ADAMK-Dancer2-Twittersect.git
all_from       lib/ADAMK/Dancer2/Twittersect.pm
requires_from  lib/ADAMK/Dancer2/Twittersect.pm
requires_from  bin/twittersect
test_requires  Test::More   1.001013
test_requires  File::Spec   0.80
test_requires  Params::Util 1.04
