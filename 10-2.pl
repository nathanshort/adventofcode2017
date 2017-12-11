#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $Line = <STDIN>;
chomp $Line;
my @Lengths = map{ ord $_ } split( //, $Line );
@Lengths = ( @Lengths, 17, 31, 73, 47, 23 );

my $CurrentPos = 0;
my $SkipSize = 0;

my @Inputs = 0..255;

for( my $Round = 0; $Round < 64; $Round ++ )
{
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
}

my @Xors;
for my $Offset ( 0..15 )
{
    my @ToXor = @Inputs[ ( $Offset * 16 )..( ( ( $Offset + 1 ) * 16 ) - 1 ) ];
    my $Partial = 0;
    foreach my $To( @ToXor )
    { $Partial = $Partial ^ $To; }
    push( @Xors, $Partial );
}

foreach my $Xor( @Xors )
{ printf( "%02x", $Xor ); }

print "\n";
