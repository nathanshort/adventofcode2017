#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw/max/;

my $Directions = <STDIN>;
chomp( $Directions );
my @Directions = split( /,/, $Directions );

sub NextPos
{
    my ( $Current, $Xinc, $Yinc ) = @_;
    $Current->{x} += $Xinc;
    $Current->{y} += $Yinc;
    $Current->{z} = 0 -  $Current->{x} -  $Current->{y};
}

sub Distance
{
    my $Position = shift;
    return max( abs( $Position->{x} ), abs( $Position->{y} ), abs( $Position->{z} ) );
}

my %Position = ( x => 0, y => 0, z => 0 );
my $MaxDistance = 0;

foreach my $Direction( @Directions )
{
    if( $Direction eq "n" )
    { NextPos( \%Position, 0, 1 ); }
    elsif( $Direction eq "ne" )
    { NextPos( \%Position, 1, 0 ); }
    elsif( $Direction eq "nw" )
    { NextPos( \%Position, -1, 1 ); }
    elsif( $Direction eq "s" )
    { NextPos( \%Position, 0, -1 ); }
    elsif( $Direction eq "se" )
    { NextPos( \%Position, 1, -1 ); }
    elsif( $Direction eq "sw" )
    { NextPos( \%Position, -1, 0 ); }
    else
    { die "unknown $Direction\n"; }

    my $Distance = Distance( \%Position );
    if( ! defined( $Distance ) || ( $Distance > $MaxDistance ) )
    { $MaxDistance = $Distance; }
}

print "distance: ", Distance( \%Position ), " max distance: $MaxDistance\n";
    
    
