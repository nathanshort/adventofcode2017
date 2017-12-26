#!/usr/bin/perl

use strict;
use warnings;

my %RealBlueprint =
    (
     'A' =>
     {
	 'branches' =>
	     [
	      { 'write' => 1, 'move' => 1, 'next' => 'B', },
	      { 'write' => 0, 'move' => -1, 'next' => 'D', }
	     ],
     },
     'B' =>
     {
	 'branches' =>
	     [
	      { 'write' => 1, 'move' => 1, 'next' => 'C', },
	      { 'write' => 0, 'move' => 1, 'next' => 'F', }
	     ],
     },
     'C' =>
     {
	 'branches' =>
	     [
	      { 'write' => 1, 'move' => -1, 'next' => 'C', },
	      { 'write' => 1, 'move' => -1, 'next' => 'A', }
	 ],
     },
     'D' =>
     {
	 'branches' =>
	     [
	      { 'write' => 0, 'move' => -1, 'next' => 'E', },
	      { 'write' => 1, 'move' => 1, 'next' => 'A', }
	 ],
     },
     'E' =>
     {
	 'branches' =>
	     [
	      { 'write' => 1, 'move' => -1, 'next' => 'A', },
	      { 'write' => 0, 'move' => 1, 'next' => 'B', }
	 ],
     },
     'F' =>
     {
	 'branches' =>
	     [
	      { 'write' => 0, 'move' => 1, 'next' => 'C', },
	      { 'write' => 0, 'move' => 1, 'next' => 'E', }
	 ],
     },
    );


my ( $NextState, $Iterations, $Cursor, $OneCount, $Blueprint ) = 
    ( 'A', 12302209, 0, 0, \%RealBlueprint );
my %Tape;

while( $Iterations-- )
{
    my $StatePrint = $Blueprint->{$NextState};

    my $ValAtPosition = $Tape{$Cursor} || 0;
    my $Branch = $StatePrint->{branches}->[$ValAtPosition];
    my $NextValue = $Branch->{write};

    $Tape{$Cursor} = $NextValue;
    $NextState = $Branch->{next};
    $Cursor += $Branch->{move};

    # keep track of ones instead of needing to re-run the list later
    $OneCount += ( $NextValue - $ValAtPosition );
}

print "Checksum $OneCount\n";
