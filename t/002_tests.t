# -*- perl -*-
use Test::More tests => 14;
use Test::Number::Delta relative => 1e-4;

BEGIN { use_ok( 'Geo::Sun' ); }

my $gs = Geo::Sun->new;
isa_ok($gs, 'Geo::Sun');
my $tropic=23 + (26 + 22/60)/60;  #Tropic of Cancer
my $summer=DateTime->new( year   => 2008,
                          month  => 6,
                          day    => 20,
                          hour   => 23,
                          minute => 59,
                          time_zone => "UTC",
                         );
isa_ok($summer, "DateTime");
my $point=$gs->point_dt($summer);
isa_ok($point, "GPS::Point");
delta_ok($point->lat, $tropic, "Summer Solstice");

my $winter=DateTime->new( year   => 2008,
                          month  => 12,
                          day    => 21,
                          hour   => 12,
                          minute => 04,
                          time_zone => "UTC",
                         );
isa_ok($winter, "DateTime");
$point=$gs->point_dt($winter);
isa_ok($point, "GPS::Point");
delta_ok($point->lat, -$tropic, "Winter Solstice");

my $spring=DateTime->new( year   => 2008,
                          month  => 3,
                          day    => 20,
                          hour   => 5,
                          minute => 48,
                          time_zone => "UTC",
                         );
isa_ok($spring, "DateTime");
$point=$gs->point_dt($spring);
isa_ok($point, "GPS::Point");
delta_within($point->lat, 0, 0.005, "Spring Equinox");

my $fall=DateTime->new( year   => 2008,
                          month  => 9,
                          day    => 22,
                          hour   => 15,
                          minute => 44,
                          time_zone => "UTC",
                         );
isa_ok($fall, "DateTime");
$point=$gs->point_dt($fall);
isa_ok($point, "GPS::Point");
delta_within($point->lat, 0, 0.005, "Fall Equinox");

