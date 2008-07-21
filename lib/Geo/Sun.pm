package Geo::Sun;
use strict;
use warnings;
use Astro::Coord::ECI::Sun;
use DateTime;
use Geo::Constants qw{PI};
use Geo::Functions qw{deg_rad};
use Geo::Ellipsoids;
use GPS::Point;

BEGIN {
    use vars qw($VERSION);
    $VERSION     = '0.01';
}

=head1 NAME

Geo::Sun - Calculates the Geodetic Position of the Sun over the Surface of the Earth

=head1 SYNOPSIS

  use Geo::Sun;
  my $gs=Geo::Sun->new;
  my $point=$gs->point_dt(DateTime->now);  #read as "Point given DateTime object";
  printf "Latitude: %s, Longitude: %s\n", $point->lat, $point->lon;

=head1 DESCRIPTION

The Geo::Sun package calculates the position of the Sun over the Earth. The single user method point_dt takes a L<DateTime> object as a parameter and returns a L<GPS::Point> which is the point on the earth where the Sun is directly over at the given time.

The Geo::Sun package is a wrapper around L<Astro::Coord::ECI::Sun> with a user friendly interface.

=head1 USAGE

  use Geo::Sun;
  my $gs=Geo::Sun->new;

=head1 CONSTRUCTOR

=head2 new

  my $gs=Geo::Sun->new;

=cut

sub new {
  my $this = shift();
  my $class = ref($this) || $this;
  my $self = {};
  bless $self, $class;
  $self->initialize(@_);
  return $self;
}

=head1 METHODS

=cut

sub initialize {
  my $self=shift;
  %$self=@_;
  $self->sun(Astro::Coord::ECI::Sun->new) unless ref($self->sun) eq "Astro::Coord::ECI::Sun";
  $self->ellipsoid(Geo::Ellipsoids->new) unless ref($self->ellipsoid) eq "Geo::Ellipsoids";
}

=head2 sun

Sets or returns the L<Astro::Coord::ECI::Sun> object.

  my $sun=$gs->sun;

=cut

sub sun {
  my $self=shift;
  $self->{'sun'}=shift if @_;
  return $self->{'sun'};
}

=head2 ellipsoid

Set or returns the L<Geo::Ellipsoids> object.

  my $ellipsoid=$gs->ellipsoid;  #WGS84

=cut

sub ellipsoid {
  my $self = shift();
  $self->{'ellipsoid'}=shift if (@_);
  return $self->{'ellipsoid'};
}

=head2 point_dt

Returns a GPS::Point given a DateTime oject 

  my $point=$gs->point_dt(DateTime->now);

=cut

sub point_dt {
  my $self=shift;
  my $dt=shift || DateTime->now;
  $dt->set_time_zone("UTC");
  my ($psi, $lambda, $h) = $self->sun->universal($dt->epoch)->geodetic;
  my $speed=2 * PI() * $self->ellipsoid->n_rad($psi) * cos($psi) / 24 / 60 / 60;  #distance from the polar axis to the surface of the earth at latitude divided by 1 day (m/s)
  my $point=GPS::Point->new(
         time        => $self->sun->universal, #float seconds from the unix epoch (UTC)
         lat         => deg_rad($psi),         #signed decimal degrees
         lon         => deg_rad($lambda),      #signed decimal degrees
         alt         => $h * 1000,             #meters above the WGS-84 ellipsoid
         speed       => $speed,                #meters/second (over ground)
         heading     => 270,                   #degrees clockwise from North
         mode        => 3,                     #GPS mode [?=>undef,None=>1,2D=>2,3D=>3]
         tag         => "Geo::Sun",            #Name of the GPS message for data
       ); 
  return $point;
}

=head1 BUGS

Please send to the geo-perl email list.

=head1 SUPPORT

Try the geo-perl email list.

=head1 AUTHOR

    Michael R. Davis
    CPAN ID: MRDVT
    STOP, LLC
    domain=>stopllc,tld=>com,account=>mdavis
    http://www.stopllc.com/

=head1 COPYRIGHT

This program is free software licensed under the...

	The BSD License

The full text of the license can be found in the
LICENSE file included with this module.

=head1 SEE ALSO

=cut

1;
