#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package HTTP::YARM::Route;

use strict;
use warnings;

use Data::Dumper;

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   $self->{'__subroutes'} = [];
   $self->{'__parameter'} = [];

   return $self;
}

sub to {
   my $self = shift;
   $self->{'to'} = shift;

   $self;
}

sub scope {
   my $self = shift;
   $self->{'__scope'} = shift;

   return $self;
}

sub route {
   my $self = shift;
   my $route = shift;

   push(@{$self->{'__subroutes'}}, ref($self)->new(route => $route, parent => $self));
   $self->{'__subroutes'}->[-1];
}

sub execute {
   my $self = shift;

   my $call = $self->{'to'};

   my @params = ();
   push(@params, $self->{'__scope'}) if(exists $self->{'__scope'});
   push(@params, @{$self->{'__parameter'}});

   return &$call(@params);
}

sub path {
   my $self = shift;
   unless($self->{'parent'}) { return $self->{'route'}; }

   return ($self->{'parent'}->is_root?'':$self->{'parent'}->path) . $self->{'route'};
}

sub parse {
   my $self = shift;
   my $url  = shift;
   my $path = $self->path;

   my @p;
   if(@p = $url =~ m/^$path$/) {
      @{$self->{'__parameter'}} = @p;
      return 1;
   }

   return undef;
}

sub is_root {
   my $self = shift;

   return ! $self->{'parent'};
}

sub get_routes {
   my $self = shift;
   my @routes = ();
   push(@routes, $self);
   for my $route (@{$self->{'__subroutes'}}) {
      push(@routes, $route->get_routes);
   }

   return @routes;
}

1;
