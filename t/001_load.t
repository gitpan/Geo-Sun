# -*- perl -*-
use Test::More tests => 6;

BEGIN { use_ok( 'Geo::Sun' ); }

my $gs = Geo::Sun->new;
isa_ok($gs, 'Geo::Sun');
isa_ok($gs->ellipsoid, "Geo::Ellipsoids");
isa_ok($gs->sun, "Astro::Coord::ECI::Sun");
isa_ok($gs->datetime, "DateTime");
isa_ok($gs->point_dt, "GPS::Point");
