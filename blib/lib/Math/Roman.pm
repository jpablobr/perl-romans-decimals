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

=head1 DESCRIPTION

Step by Step description of how the DecimalsToRomans function work:

# This Hash will hold the relations between the romans and arabic numbers.
our %roman_map = qw(
    I 1 IV 4 V 5 IX 9 X 10 XL 40 L 50 XC 90 C 100 CD 400 D 500 CM 900 M 1000
);

# Get the arabic # we want to convert.
my $arabic = shift;

# It has to be < that 39999.
exit if ($arabic > 4000);

# Here we'll store the roman number concatenated value.
my $roman;

# We need to sort the keys in a descending fasion since later on we need to
# evaluate if the arabic number (the input) is in one of the %arabic_map hash
# "range/sets" we defined. If its not (sorted descending), and lets say the
# input number is 7... (for the type of argorith implemented) it may match "I"
# before "V", and as later on will be explained, this will produce the wrong
# output.
# Example:
# Again, if we entered 7, its first match should be "V" (kinda-sorta
# its roman # "range/set"). This will later on help in order to substract
# "V" (or 5 since it's == "V") to the original 7 and continue iterating.
# Since now the $arabic number is 2! (remember the substraction), the next
# match will be "I" which in turn we'll be matched twice. Now we can just
# concatenate the "matched in range" values to the $roman scalar, so we can
# finally display a string such as "VII" (7).
foreach my $key ( sort hashValueDescendingNum(keys(%roman_map))) {

    # The desending sorted hash output:
    # print "<<< Inside foreach: ", $roman_map{$key}, " >>>\n";
    # It would be something like this:
    # <<< Inside foreach: 1000 >>>
    # <<< Inside foreach: 900 >>>
    # <<< Inside foreach: 500 >>>
    # <<< Inside foreach: 400 >>>
    # <<< Inside foreach: 100 >>>
    # <<< Inside foreach: 90 >>>
    # <<< Inside foreach: 50 >>>
    # <<< Inside foreach: 40 >>>
    # <<< Inside foreach: 10 >>>
    # <<< Inside foreach: 9 >>>
    # <<< Inside foreach: 5 >>>
    # <<< Inside foreach: 4 >>>
    # <<< Inside foreach: 1 >>>

    # Evalutate if the arabic # entered is > or = to
    # the current %roman_map hash key being evaluated so we can:
    # One, grab the roman first "matched in range" value.
    # Two, substract the matched roman value to the original input number.
    # If $arabic == 7, 5 ("V") will be matched...
    # Therefore, we'll end up with 2 (which will be matched twice).
    while ($arabic >= $roman_map{$key}) {
        # Substraction.
        $arabic = $arabic - $roman_map{$key};
        # Concatenate the matches.
        $roman .= $key;

        # The matched keys:
        # print "<<< inside while loop, key: ", $key, " >>>\n";
        # Again, for an input of 7 it would display the following:
        # <<< inside while loop, key: V >>>
        # <<< inside while loop, key: I >>>
        # <<< inside while loop, key: I >>>
    }
}

print "<<< The roman value is: ", $roman, " >>>\n";

# http://perlmeme.org/tutorials/sort_function.html
# $a and $b are special var in Perl!.
# Therefore, besides the sorting meant
# functionality they do not need to be declared with my.
sub hashValueDescendingNum {
   $roman_map{$b} <=> $roman_map{$a};
}

=head2 EXPORT

None by default.

=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

jpablobr, E<lt>jpablobr@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by jpablobr

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.

=cut
