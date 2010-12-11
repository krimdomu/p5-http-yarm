#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

use strict;
use warnings;

use Test::More tests => 14;

use_ok 'HTTP::YARM';

my $r = HTTP::YARM->new;
ok($r);

my $root = $r->route('/')->to(sub { return 'root'; });
$root->route('/test1')->to(sub{ return 'test1'; });
$root->route('/test/(\d+)')->to(sub{ return $_[0]; });
$r->route('/root')->to(sub { return '/root'; });
$root->route('/post', method => [qw(post)])->to(sub { return '/post'; });
$root->route('/post_and_get', method => [qw(post get)])->to(sub { return '/post_and_get'; });
$root->route('/any', method => [qw(any)])->to(sub { return '/any'; });

ok($r->parse(url => '/')->execute eq 'root');
ok($r->parse(url => '/test1')->execute eq 'test1');
ok($r->parse(url => '/test/5')->execute == 5);
ok($r->parse(url => '/root')->execute eq '/root');
ok($r->parse(url => '/post', method => 'post')->execute eq '/post');
eval {
   $r->parse(url => '/post', method => 'get')->execute;
};
ok($@);
ok($r->parse(url => '/post_and_get', method => 'POST')->execute eq '/post_and_get');
ok($r->parse(url => '/post_and_get', method => 'post')->execute eq '/post_and_get');
ok($r->parse(url => '/post_and_get', method => 'GET')->execute eq '/post_and_get');
ok($r->parse(url => '/post_and_get', method => 'get')->execute eq '/post_and_get');
ok($r->parse(url => '/any', method => 'get')->execute eq '/any');
ok($r->parse(url => '/any')->execute eq '/any');

