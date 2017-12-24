#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use POSIX;

use constant { ORIENTATION_LEFT => 1,
	       ORIENTATION_RIGHT => 2,
	       ORIENTATION_UP => 3,
	       ORIENTATION_DOWN => 4,
};

my %Points;
my ( $Rows, $RowCount ) = ( 0, undef );
while( my $Line = <STDIN> )
{
    my $Column = 0;
    chomp( $Line );
    my @Chars = split( //, $Line );
    $RowCount = scalar( @Chars );
    foreach my $Char( @Chars )
    {
	my $Key = "$Rows,$Column";
	$Points{$Key} = $Char;
	$Column++;
    }
    $Rows++;
}


my ( $Column, $Row, $CurrentOrientation ) = 
    ( ceil( $Rows / 2 ) - 1, ceil( $RowCount / 2 ) - 1, 
      ORIENTATION_UP );


my $InfectionBursts = 0;
for( my $Iteration = 0; $Iteration < $ARGV[0]; $Iteration++ )
{
    if( !( $Iteration % 100000 ) )
    { print "iteration $Iteration\n"; }

    my ( $Key, $NextOrientation, $DoTurn ) = ( "$Row,$Column", undef, 1 );
    
    if( defined( $Points{$Key} ) && $Points{$Key} eq "#" )
    {
	$Points{$Key} = "F";
	$NextOrientation = ORIENTATION_RIGHT;
    }
    elsif( defined( $Points{$Key} ) && $Points{$Key} eq "W" )
    {
	$Points{$Key} = "#";
	$NextOrientation = $CurrentOrientation;
	$DoTurn = 0;
	$InfectionBursts++;
    }
    elsif( defined( $Points{$Key} ) && $Points{$Key} eq "F" )
    {
	$Points{$Key} = ".";
	if( $CurrentOrientation == ORIENTATION_RIGHT )
	{ $NextOrientation = ORIENTATION_LEFT; }
	elsif( $CurrentOrientation == ORIENTATION_LEFT )
	{ $NextOrientation = ORIENTATION_RIGHT; }
	elsif( $CurrentOrientation == ORIENTATION_UP )
	{ $NextOrientation = ORIENTATION_DOWN; }
	elsif( $CurrentOrientation == ORIENTATION_DOWN )
	{ $NextOrientation = ORIENTATION_UP; }
	$CurrentOrientation = ORIENTATION_UP;

    }
    else
    {
	$Points{$Key} = "W";
	$NextOrientation = ORIENTATION_LEFT;

    }

    # calc next iteration's key
    $Key =~ m/(.*),(.*)/;
    ( $Row, $Column ) = ( $1, $2 );

    
    if( $CurrentOrientation == ORIENTATION_UP )
    {
	if( $DoTurn )
	{
	    if( $NextOrientation == ORIENTATION_LEFT )
	    { $Column--; }
	    elsif( $NextOrientation == ORIENTATION_RIGHT )
	    { $Column++; }
	    elsif( $NextOrientation == ORIENTATION_DOWN )
	    { $Row++; }
	    elsif( $NextOrientation == ORIENTATION_UP )
	    { $Row--; }
	}
	else
	{ $Row--; }
    }
    elsif( $CurrentOrientation == ORIENTATION_DOWN )
    {
	if( $DoTurn )
	{
	    if( $NextOrientation == ORIENTATION_LEFT )
	    { 
		$Column++;
		$NextOrientation = ORIENTATION_RIGHT;
	    }
	    elsif( $NextOrientation == ORIENTATION_RIGHT )
	    { 
		$Column--;
		$NextOrientation = ORIENTATION_LEFT;
	    }
	    elsif( $NextOrientation == ORIENTATION_UP )
	    { $Row--; }
	}
	else
	{ $Row++; }
    }
    elsif( $CurrentOrientation == ORIENTATION_LEFT )
    {
	if( $DoTurn )
	{
	    if( $NextOrientation == ORIENTATION_LEFT )
	    {
		$Row++;
		$NextOrientation = ORIENTATION_DOWN;
	    }
	    elsif( $NextOrientation == ORIENTATION_RIGHT )
	    { 
		$Row--;
		$NextOrientation = ORIENTATION_UP;
	    }
	}
	else
	{ $Column--; }
    }
    elsif( $CurrentOrientation == ORIENTATION_RIGHT )
    {
	if( $DoTurn )
	{
	    if( $NextOrientation == ORIENTATION_LEFT )
	    { 
		$Row--;
		$NextOrientation = ORIENTATION_UP;
	    }
	    elsif( $NextOrientation == ORIENTATION_RIGHT )
	    { 
		$Row++;
		$NextOrientation = ORIENTATION_DOWN;
	    }
	}
	else
	{ $Column++; }
    }
    $CurrentOrientation = $NextOrientation;
}


print "Bursts: $InfectionBursts\n";
