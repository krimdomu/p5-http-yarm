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

   if(ref($_[0]) eq "CODE") {
      $self->{'to'} = shift;
   } elsif($_[0] eq "controller" && $_[2] eq "action") {
      $self->{'to'} = {@_};
   } else {
      # error
   }

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

   my @params = ();
   push(@params, $self->{'__scope'}) if(exists $self->{'__scope'});
   push(@params, @{$self->{'__parameter'}});

   if(ref($self->{'to'}) eq "CODE") {
      my $call = $self->{'to'};
      return &$call(@params);
   } elsif(ref($self->{'to'}) eq "HASH") {
      my $class_str = $self->{'to'}->{'controller'};
      my $func = $self->{'to'}->{'action'};
      if(ref($func) eq "CODE") {
         return &$func($class_str->new, @params);
      } else {
         return $class_str->new()->$func(@params);
      }
   }
}

sub path {
   my $self = shift;
   unless($self->{'parent'}) { return $self->{'route'}; }

   return $self->{'route'} if($self->is_root);
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
   return ref($self->{'parent'}) ne 'HTTP::YARM::Route';
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
