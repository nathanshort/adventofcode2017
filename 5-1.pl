#!/usr/bin/perl

use strict;
use warnings;

my @Input = ();
while( my $Line = <STDIN> )
{
    chomp( $Line );
    push( @Input, $Line );
}

my ( $Index, $Steps ) = ( 0, 0 );
my $Size = scalar( @Input );

while( ( $Index < $Size ) && ( $Index >= 0 ) )
{
    my $Value = $Input[$Index];
    $Input[$Index]++;
    $Index += $Value;
    $Steps++;
}

print "Steps: $Steps\n";
