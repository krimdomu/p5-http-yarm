use strict;
use warnings;
use Data::Dumper;

use lib '/Users/jan/Projekte/p5-yarm/lib';

use HTTP::YARM -namespace => 'App::Controller';

my $r = HTTP::YARM->new;

# /
my $root = $r->route('/')->to(sub { print "huhu\n"; });
my $hi_route = $root->route('/hi')->to(sub { print "gugu\n"; });
$root->route('/ho')->to(sub { print "hoho\n"; });

my $r2 = $hi_route->route(qr{/name/([a-z]+)})->to(sub { print join(" -> ", @_) . "\n"; });
$r2->route('/del')->to(sub { print "ganz weit unten\n"; });

$r->route('/wupp/humm/bla/(\d+)/([a-z]+)')->to(sub { print "lange url\n"; print join(" -> ", @_) ."\n"; });

$r->route('/entry')->to(sub { my($self, $mvc) = @_; return $self->index($mvc); });
$r->route('/entry/([a-z]+)')->to(sub { my($self, $mvc, $action) = @_; return $self->$action($mvc); });


#print Dumper($r);

my @routes = grep { $_ = $_->path } $r->get_routes;
print Dumper(@routes);

my $ret = $r->parse('/wupp/humm/bla/9/jan');
#print Dumper($ret->path);
#$ret->scope($mvc);

$ret->execute;

#$ret->execute();




# /list
#my $list = $root->route('/list')->to(sub {});
#$root->before(sub {});
#$root->after(sub{});
#$root->around(sub{});

#$r->route('/blub')->to(controller => 'blub', action => 'index');
#$r->route('/login')->redirect('http://heise.de');

# /list/all
#$list->route('/all')->to(sub{});



