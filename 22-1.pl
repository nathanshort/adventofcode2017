#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use POSIX;

use constant { ORIENTATION_LEFT => 0,
	       ORIENTATION_RIGHT => 1,
	       ORIENTATION_UP => 2,
	       ORIENTATION_DOWN => 3,
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
    my $Key = "$Row,$Column";
    my $NextOrientation = undef;
    if( defined( $Points{$Key} ) && $Points{$Key} eq "#" )
    {
	$Points{$Key} = ".";
	$NextOrientation = ORIENTATION_RIGHT;
    }
    else
    {
	$Points{$Key} = "#";
	$InfectionBursts++;
	$NextOrientation = ORIENTATION_LEFT;

    }

    $Key =~ m/(.*),(.*)/;
    ( $Row, $Column ) = ( $1, $2 );

    if( $CurrentOrientation == ORIENTATION_UP )
    {
	if( $NextOrientation == ORIENTATION_LEFT )
	{ $Column--; }
	elsif( $NextOrientation == ORIENTATION_RIGHT )
	{ $Column++; }
    }
    elsif( $CurrentOrientation == ORIENTATION_DOWN )
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
    }
    elsif( $CurrentOrientation == ORIENTATION_LEFT )
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
    elsif( $CurrentOrientation == ORIENTATION_RIGHT )
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

    
    $CurrentOrientation = $NextOrientation;
}


print "Bursts: $InfectionBursts\n";
