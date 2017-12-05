#!/usr/bin/perl

use strict;
use warnings;

my $Checksum = 0;

while ( my $Line = <STDIN> )
{
    chomp( $Line );
    my @Numbers = split( /\s+/, $Line );

    my $Found = undef;
    for( my $i = 0; ( $i < scalar( @Numbers ) ) && ! defined( $Found ); $i++ )
    {
	for( my $j = 0; ( $j < scalar( @Numbers ) ) && ! defined( $Found ); $j++ )
	{
	    if( $i == $j )
	    { next; }
	    
	    my $Remainder = $Numbers[$i] % $Numbers[$j];
	    if( $Remainder == 0 )
	    {
		$Checksum += ( $Numbers[$i] / $Numbers[$j] );
		$Found = 1;
		last;
	    }

	    $Remainder = $Numbers[$j] % $Numbers[$i];
	    if( $Remainder == 0 )
	    {
		$Checksum += $Numbers[$j] / $Numbers[$i];
		$Found = 1;
	    }
	}

    }
}

print "$Checksum\n";


