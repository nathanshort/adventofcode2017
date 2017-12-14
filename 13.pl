#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my @Scanner = ();

while( my $Line = <STDIN> )
{
    chomp( $Line );
    if( $Line =~ m/^(\d+): (\d+)$/)
    { $Scanner[$1] = $2; }
    else
    { die "no match $Line\n"; }
}

my ( $Delay, $Hit, $Severity ) = ( 0, 0, 0 );

( $Hit, $Severity ) = doscan( $Delay );
print "part one severity: $Severity\n";

while( 1 )
{
    my ( $Hit, $Severity ) = doscan( $Delay );
    if( ! $Hit )
    { 
	print "part 2 delay: $Delay\n";
	last;
    }
    $Delay++;
}


# returns ( Hit (0/1), Severity )
# checking Severity is not enough, as there could be
# a hit at spot 0 only, which counts as 0 severity
sub doscan
{
    my ( $Delay, $Severity, $Hit ) = ( shift, 0, 0 );
    for( my $i = 0; $i < scalar( @Scanner ); $i++ )
    {
	if( defined( $Scanner[$i] ) && ( ! ( ($i + $Delay) % ( ($Scanner[$i] - 1) * 2 ) ) ) )
	{
	    # short circuit outta here if we are evaluating in delay mode
	    if( $Delay )
	    { return ( 1, undef ); }
	    
	    $Hit = 1;
	    $Severity += ( $i * $Scanner[$i] );
	}
    }
    
    return ( $Hit, $Severity );
}   

