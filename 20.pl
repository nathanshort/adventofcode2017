#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw/first_index uniq/;
use List::Util qw/min/;

my @Particles;

my ( $MinAccel, $MinAccelIndex, $Index ) = ( undef, undef, 0 );

while( my $Line = <STDIN> )
{
    chomp( $Line );
    if( $Line =~ m/p=<(.*)>, v=<(.*)>, a=<(.*)>$/ )
    {
	my @p = split(/,/, $1 );
	my @v = split(/,/, $2 );
	my @a = split(/,/, $3 );
	push( @Particles, { p => \@p , v => \@v, a => \@a } );
	my $AccelMagnitude = 
	    abs( $Particles[$Index]->{a}->[0] ) + 
	    abs( $Particles[$Index]->{a}->[1] ) + 
	    abs( $Particles[$Index]->{a}->[2] );

	if( ! defined( $MinAccel ) || ( $AccelMagnitude < $MinAccel ) )
	{ 
	    $MinAccel = $AccelMagnitude;
	    $MinAccelIndex = $Index;
	}
    }
    else
    { die "bad line $Line\n";}

    $Index++;
}


# somewhat cheating here.  we could have multiples with the same - then we'd need
# to run the calcs
print "part1: $MinAccelIndex\n";
print "part2: " . detectcollisions( 1 ) . "\n";


sub detectcollisions
{
    my ( $RemoveCollisions ) = @_;
    my $IterationCount = 0;
    
    # iterate the particles until all of them are now in their terminal direction
    # in the x, y, and z axis.  Once that is true, find the particle that has
    # the smallest acceleration magnitude.  That is the long term closest to zero particle
    while( 1 )
    {
	$IterationCount++;
	
	my $SameSignCount = 0;

	# keeps count of Position -> Number of particles at that position
	my %Positions;
	
	for( my $i = 0; $i < scalar( @Particles ); $i++ )
	{
	    my $Particle = $Particles[$i];
	    
	    #x = 0, y = 1, z = 2
	    $Particle->{v}->[0] += $Particle->{a}->[0];
	    $Particle->{v}->[1] += $Particle->{a}->[1];
	    $Particle->{v}->[2] += $Particle->{a}->[2];
	    $Particle->{p}->[0] += $Particle->{v}->[0];
	    $Particle->{p}->[1] += $Particle->{v}->[1];
	    $Particle->{p}->[2] += $Particle->{v}->[2];

	    # determine if acceleration and velocity have the same sign yet.
	    if( ( $Particle->{a}->[0] == 0 ||
		  $Particle->{a}->[1] == 0 ||
		  $Particle->{a}->[2] == 0 ) ||
		( ( $Particle->{a}->[0] < 0 == $Particle->{v}->[0] < 0 ) &&
		  ( $Particle->{a}->[1] < 0 == $Particle->{v}->[1] < 0 ) &&
		  ( $Particle->{a}->[2] < 0 == $Particle->{v}->[2] < 0 ) ) )
	    { $SameSignCount++; }
	 
	    # create a position key to compare like positions
	    $Positions{ join("-", $Particle->{p}->[0], $Particle->{p}->[1], $Particle->{p}->[2] ) }++;
	}

	# if all particles have oriented themselves in their final direction, then we are done
	if( $SameSignCount == scalar( @Particles ) )
	{ last; }
	
	my @NewParticles;
	for( my $j = 0; $RemoveCollisions && ( $j < scalar( @Particles ) ); $j++ )
	{
	    my $Particle = $Particles[$j];
	    my $Position = join("-", $Particle->{p}->[0], $Particle->{p}->[1], $Particle->{p}->[2] );
	    if( $Positions{$Position} == 1 )
	    { push( @NewParticles, $Particles[$j] ); }
	}
	
	@Particles = @NewParticles;
    }

#    print $IterationCount, "\n";
    
    return scalar( @Particles );
}
