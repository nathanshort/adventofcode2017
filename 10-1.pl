#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $Line = <STDIN>;
chomp $Line;
my @Lengths = split( /,/, $Line );

my $CurrentPos = 0;
my $SkipSize = 0;

my @Inputs = 0..255;

foreach my $Length( @Lengths )
{
    my @SubList;
    for( my $i = 0; $i < $Length; $i++ )
    {
	my $Index = ( $CurrentPos + $i ) % scalar( @Inputs );
	push( @SubList, $Inputs[$Index] );
    }
    
    my( $SpotsBack, $SpotsFront ) = ( 0,0 );
    if( ( $CurrentPos + $Length ) >= scalar( @Inputs ) )
    {
	$SpotsBack = scalar( @Inputs ) - $CurrentPos;
	$SpotsFront = $Length - $SpotsBack;
    }
    else
    { $SpotsBack = $Length; }
    
    my @Reversed = reverse( @SubList );

    if( $SpotsBack )
    { splice( @Inputs, $CurrentPos, $SpotsBack, @Reversed[ 0..($SpotsBack - 1 )] ); }

    if( $SpotsFront )
    { splice( @Inputs, 0, $SpotsFront, @Reversed[ ( $SpotsBack )..( $Length - 1 )] ); }

    $CurrentPos = ( $CurrentPos + $Length + $SkipSize++ ) % scalar( @Inputs );
}

print $Inputs[0] * $Inputs[1], "\n";
