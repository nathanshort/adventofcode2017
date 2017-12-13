#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# map Program -> neighbors
my %Programs = ();


while( my $Line = <STDIN> )
{
    chomp( $Line );
    if( $Line =~ m/^(\d+) <-> (.*)$/ )
    {
	my ( $Program, @Neighbors ) =  ( $1 - '0', map { $_ - '0' } split( ", ", $2 ) );
	$Programs{$Program} = \@Neighbors;
    }
    else
    { die "NO MATCH $Line\n";  }
}


# how many unique groups we have
my $GroupCounts = 0;

# for each program, which programs are accessible from that program
my %HitsByProgram = ();

# all programs that we've seen
my %AllHits = ();



foreach my $Program( sort keys %Programs )
{
    if( defined( $AllHits{$Program} ) )
    { next; }

    $GroupCounts++;
    Trace( $Program, $Programs{$Program} );
}


print "matches for 0:" , scalar keys %{$HitsByProgram{0}}, " total groups:", $GroupCounts, "\n";


sub Trace
{
    my ( $ProgramHead, $ProgramRef ) = @_;
    
    foreach my $Program( @{ $ProgramRef } )
    {
	if( ! defined( $HitsByProgram{$ProgramHead}{$Program} ) )
	{
	    $AllHits{$Program} = 1;
	    $HitsByProgram{$ProgramHead}->{$Program} = 1;
	    Trace( $ProgramHead, $Programs{$Program} );
	}
    }
}
