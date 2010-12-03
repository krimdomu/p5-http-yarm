#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

use strict;
use warnings;

use Test::More tests => 6;

use_ok 'HTTP::YARM';

my $r = HTTP::YARM->new;
ok($r);

my $root = $r->route('/')->to(sub { return 'root'; });
$root->route('/test1')->to(sub{ return 'test1'; });
$root->route('/test/(\d+)')->to(sub{ return $_[0]; });
$r->route('/root')->to(sub { return '/root'; });

ok($r->parse('/')->execute eq 'root');
ok($r->parse('/test1')->execute eq 'test1');
ok($r->parse('/test/5')->execute == 5);
ok($r->parse('/root')->execute eq '/root');


