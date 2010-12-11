#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package HTTP::YARM;

use strict;
use warnings;

our $VERSION = '0.0.1';

use HTTP::YARM::Route;

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   $self->{'__routes'} = [];

   return $self;
}

sub route {
   my $self = shift;
   my $route = shift;
   my $params = {};

   if($#_ > 0) {
      $params = { @_ };
   }

   push(@{$self->{'__routes'}}, HTTP::YARM::Route->new(route => $route, parent => $self, %$params));

   $self->{'__routes'}->[-1];
}


sub get_routes {
   my $self = shift;
   my @routes = ();

   for my $route (@{$self->{'__routes'}}) {
      push(@routes, $route->get_routes);
   }

   @routes;
}

sub parse {
   my $self = shift;
   my $p = { @_ };
   my $url = $p->{'url'};
   my $method = $p->{'method'} || 'any';

   my @routes = $self->get_routes;

   my ($route) = grep { $_->parse(url => $url, method => $method) } @routes;

   return $route;
}

1;
