#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package HTTP::YARM;

use strict;
use warnings;

use HTTP::YARM::Route;

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = {};

   bless($self, $proto);

   $self->{'__routes'} = [];

   return $self;
}

sub route {
   my $self = shift;
   my $route = shift;

   push(@{$self->{'__routes'}}, HTTP::YARM::Route->new(route => $route));

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
   my $url  = shift;
   my @routes = $self->get_routes;

   my ($route) = grep { $_->parse($url) } @routes;

   return $route;
}

1;
