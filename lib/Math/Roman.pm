package Math::Roman;

use 5.010001;
use strict;
use warnings;

our %roman_map = qw(
    I 1 IV 4 V 5 IX 9 X 10 XL 40 L 50 XC 90 C 100 CD 400 D 500 CM 900 M 1000
);
our %roman2arabic = qw(
    I 1 V 5 X 10 L 50 C 100 D 500 M 1000
);

sub new {
    my $self = {};
    my $package = shift;
    bless($self, $package);
    return $self;
}

sub DecimalToRoman {
    my ($self, $arabic, $roman) = @_;

    return undef and
        exit if validateDTRInput(@_);

    for ( sort hashValueDescendingNum(keys(%roman_map))) {
        while ($arabic >= $roman_map{$_}) {
            $arabic = $arabic - $roman_map{$_};
            $roman .= $_;
        }
    }
    $roman;
}

sub RomanToDecimal {
    my ($self, $roman, $arabic) = @_;

    return undef and
        exit if validateRTNInput(@_);

    my $last_digit = 1000;
    for (split(//, uc $roman)) {
        my $digit = $roman2arabic{$_};
        $arabic -= 2 * $last_digit if $last_digit < $digit;
        $arabic += ($last_digit = $digit);
    }
    $arabic;
}

sub validateRTNInput {
    my ($self, $roman) = @_;

    return 1 if
        !defined $roman ||
        $roman eq '' ||
        $roman !~ /^(?: M{0,3})
                (?: D?C{0,3} | C[DM])
                (?: L?X{0,3} | X[LC])
                (?: V?I{0,3} | I[VX])$/ix ||
        @_ >= 3;
    return 0;
}

sub validateDTRInput {
    my ($self, $arabic) = @_;

    return 1 if
        !defined $arabic ||
        $arabic !~ /^[+-]?\d+$/ ||
        $arabic > 4000 ||
        @_ >= 3;
    return 0;
}

sub hashValueDescendingNum {
   $roman_map{$b} <=> $roman_map{$a};
}

"0 but true";

__END__


=head1 NAME

Math::Roman - Perl extension Roman to Arabic conversion

=head1 SYNOPSIS

  use Math::Roman;

  Main methods:

  DecimalToRoman()
  RomanToDecimal()

  $r = Math::Roman->new;
  $r->DecimalToRoman( 3 ); # will return "III"
  $r->RomanToDecimal( "III" ); # will return 3

=head1 AUTHOR

jpablobr, E<lt>jpablobr@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by jpablobr

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.

=cut
