# nothing... 
#     really.
use strict;
use warnings;
use Data::Dumper;

use HTTP::YARM;

my $r = HTTP::YARM->new;

# /
my $root = $r->route('/')->to(sub { print "huhu\n"; });
my $hi_route = $root->route('/hi')->to(sub { print "gugu\n"; });
$root->route('/ho')->to(sub { print "hoho\n"; });

my $r2 = $hi_route->route(qr{/name/([a-z]+)})->to(sub { print join(" -> ", @_) . "\n"; });
$r2->route('/del')->to(sub { print "ganz weit unten\n"; });

$r->route('/wupp/humm/bla/(\d+)/([a-z]+)')->to(sub { print "lange url\n"; print join(" -> ", @_) ."\n"; });

#print Dumper($r);

my @routes = grep { $_ = $_->path } $r->get_routes;
print Dumper(@routes);

my $ret = $r->parse('/wupp/humm/bla/9/jan');
#$ret->scope($x);

$ret->execute;

