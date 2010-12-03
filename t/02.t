#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package TestController;

use strict;
use warnings;

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   return $self;
}

sub do_test1 { shift->ret_sth('do_test1'); }
sub do_test2 { shift->ret_sth('do_test2'); }
sub do_test3 { shift->ret_sth(@_); }
sub do_test4 { shift->ret_sth(@_); }
sub do_test6 { shift->ret_sth(join("-", @_)); }

sub ret_sth { $_[1];}

1;

package main;

use strict;
use warnings;

use Test::More tests => 9;

use_ok 'HTTP::YARM';

my $r = HTTP::YARM->new;
ok($r);

my $root = $r->route('/')->to(controller => 'TestController', action => 'do_test1');
$root->route('/do_test2')->to(controller => 'TestController', action => \&TestController::do_test2);
$root->route('/do_test3/(\d+)')->to(controller => 'TestController', action => 'do_test3');
$root->route('/do_test4/(\d+)')->to(controller => 'TestController', action => \&TestController::do_test4);
my $route_test5 = $root->route(qr{/do_test5/(\d+)})->to(controller => 'TestController', action => 'do_test3');
my $route_test6 = $root->route(qr{/do_test6/(\d+)})->to(controller => 'TestController', action => \&TestController::do_test4);
$route_test5->route(qr{/([a-z]+)})->to(sub { return join("-", @_) });
$route_test6->route(qr{/([a-z]+)})->to(controller => 'TestController', action => 'do_test6');



ok($r->parse('/')->execute eq 'do_test1');
ok($r->parse('/do_test2')->execute eq 'do_test2');
ok($r->parse('/do_test3/7')->execute == 7);
ok($r->parse('/do_test4/777')->execute == 777);
ok($r->parse('/do_test5/8')->execute == 8);
ok($r->parse('/do_test6/778')->execute == 778);
ok($r->parse('/do_test5/779/del')->execute eq "779-del");


