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

sub ret_sth { $_[1];}

1;

package main;

use strict;
use warnings;

use Test::More tests => 6;

use_ok 'HTTP::YARM';

my $r = HTTP::YARM->new;
ok($r);

my $root = $r->route('/')->to(controller => 'TestController', action => 'do_test1');
$root->route('/do_test2')->to(controller => 'TestController', action => \&TestController::do_test2);
$root->route('/do_test3/(\d+)')->to(controller => 'TestController', action => 'do_test3');
$root->route('/do_test4/(\d+)')->to(controller => 'TestController', action => \&TestController::do_test4);

ok($r->parse('/')->execute eq 'do_test1');
ok($r->parse('/do_test2')->execute eq 'do_test2');
ok($r->parse('/do_test3/7')->execute == 7);
ok($r->parse('/do_test4/777')->execute == 777);


