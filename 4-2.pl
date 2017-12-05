#!/usr/bin/perl

use strict;
use warnings;

my $ValidCount = 0;
my $TotalCount = 0;

while ( my $Line = <STDIN> )
{
    $TotalCount++;
    chomp( $Line );
    my @Pieces = split( /\s+/, $Line );
    my %Parts = ();
    foreach my $Piece( @Pieces )
    { 
	my $Sorted  = join( "", sort( split( //, $Piece ) ) );
	$Parts{$Sorted} = 1; 
    }
    
    if( scalar( @Pieces) == scalar( keys( %Parts ) ) )
    { $ValidCount++; }
}

print "Valid: $ValidCount Total: $TotalCount\n";
