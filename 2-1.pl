#!/usr/bin/perl

use strict;
use warnings;

my $Checksum = 0;

while ( my $Line = <STDIN> )
{
    chomp( $Line );
    my @Numbers = split( /\s+/, $Line );
    my ( $Min, $Max ) = undef;
    foreach my $Number( map { $_ - '0' } @Numbers )
    {
	if( ! defined( $Min ) || ( $Number < $Min ) )
	{ $Min = $Number; }

	if( ! defined( $Max ) || ( $Number > $Max ) )
	{ $Max = $Number; }
    }

    $Checksum = $Checksum + $Max - $Min;
}

print "$Checksum\n";
