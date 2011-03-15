use Test::More qw(no_plan);
use Math::Roman;
our %test;
BEGIN{
%test=(
 'I'=>1,
 'II'=>2,
 'III'=>3,
 qw/V 5 X 10 L 50 C 100 D 500 M 1000 MCDXLIV 1444 MMVII 2007/
);
}

use_ok 'Math::Roman';
require_ok( 'Math::Roman');

$r = Math::Roman->new;
isa_ok( $r, 'Math::Roman'  );
ok( defined $r,            );
ok( $r->isa('Math::Roman') );

while (my ($rom,$arab)=each %test) {
    is( $r->DecimalToRoman( $arab ), $rom );
    is( $r->RomanToDecimal( $rom), $arab );
}

is( $r->DecimalToRoman( 3 ), "III" );
is( $r->DecimalToRoman( "fred" ), undef, 'undef for 4000 return' );
is( $r->DecimalToRoman( 3999 ), "MMMCMXCIX" );
is( $r->DecimalToRoman( 0 ), undef );
is( $r->DecimalToRoman( "" ), undef );
is( $r->DecimalToRoman( 3,7 ), undef );
is( $r->DecimalToRoman( -5 ), undef );
is( $r->DecimalToRoman( 4.1 ), undef );
is( $r->DecimalToRoman( 8 ), "VIII" );
is( $r->DecimalToRoman( 8, 7 ), undef );
is( $r->DecimalToRoman( 18 ), "XVIII" );
is( $r->DecimalToRoman( 1888 ), "MDCCCLXXXVIII" );
is( $r->DecimalToRoman( 1999 ), "MCMXCIX" );
is( $r->DecimalToRoman( 6272839 ), undef );
is( $r->DecimalToRoman( 12 ), "XII" );
is( $r->DecimalToRoman( 124 ), "CXXIV" );
is( $r->DecimalToRoman( 444 ), "CDXLIV" );
is( $r->DecimalToRoman( ), undef );
is( $r->DecimalToRoman( undef ), undef );
is( $r->DecimalToRoman( 15 ), "XV" );

# RomanToDecimal
is( $r->RomanToDecimal( "XII" ), 12 );
is( $r->RomanToDecimal( "CXXIV" ), 124 );
is( $r->RomanToDecimal( "VIII" ), 8 );
is( $r->RomanToDecimal( "XVIII" ), 18 );
is( $r->RomanToDecimal( "MDCCCLXXXVIII" ), 1888 );
is( $r->RomanToDecimal( "MCMXCIX" ), 1999 );
is( $r->RomanToDecimal( "I" ), 1 );
is( $r->RomanToDecimal( "MMMCMXCIX" ), 3999 );
is( $r->RomanToDecimal( "IIVLCDCMMM" ), undef );
is( $r->RomanToDecimal( "" ), undef );
is( $r->RomanToDecimal( "mdccclxxxviii" ), 1888 );
is( $r->RomanToDecimal( "I", "IV" ), undef );
is( $r->RomanToDecimal( ), undef );
is( $r->RomanToDecimal( "fred" ), undef );
is( $r->RomanToDecimal( "VIIII"), undef );
is( $r->RomanToDecimal( "XXC"), undef );
is( $r->RomanToDecimal( "CCM"), undef );
is( $r->RomanToDecimal( 1.2345), undef );
is( $r->RomanToDecimal( undef), undef );

# DecimalToRoman() and RomanToDecimal() are symmetric in terms of correct
# inputs. We can do both to get back the original input value
foreach my $value( 1 .. 3999 ) {
  my $result= $r->RomanToDecimal( $r->DecimalToRoman( $value ) );
  is ($result, $value);
}
