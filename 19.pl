#!/usr/bin/perl

use strict;
use warnings;
use List::MoreUtils qw/first_index/;
use Data::Dumper;

use constant {
    DOWN => 0,
    INTERSECTION => 1,
    RIGHT => 2,
    LEFT => 3,
    UP => 4,
};
    

my @Matrix;
while( my $Line = <STDIN> )
{
    chomp( $Line );
    my @Chars = split( //, $Line );
    push( @Matrix, \@Chars );
}


# start out at the first pipe in the first row
my %Pos = ( 'y' => 0, 'x' => first_index { $_ eq "|" } @{$Matrix[0]} );
my ( $CurrentDirection, $PreviousDirection ) = ( DOWN, DOWN );
my %PreviousPos = ( y => 0, x => 0 );

# keep track of chars that were consumed
my @Consumed = ();
my $Steps = 1;

while( 1 )
{
    my @PossibleNexts;

    # if we are going in a direction previously, keep going in that direction
    if( ( $CurrentDirection == DOWN ) || ( $CurrentDirection == UP ) )
    { @PossibleNexts =  ( { x => 0, y => 1 }, { x => 0, y => -1 } ); }
    elsif( ( $CurrentDirection == LEFT ) || ( $CurrentDirection == RIGHT ) )
    { @PossibleNexts = ( {  x => -1, y => 0 }, { x => 1, y => 0 } ); }

    # else we are at an intersection previously, so seek out the next spot. 
    elsif( $CurrentDirection == INTERSECTION )
    {
	push( @PossibleNexts, ( { x => 0, y => -1 },
				{ x => 0, y => 1 },
				{ x => 1, y => 0 },
				{ x => -1, y => 0 } ) );
    }
    
    my $Next = consume( \%Pos, \%PreviousPos, \@PossibleNexts );
    if( ! defined( $Next ) )
    { last; }

    my $CurrentTmp = $CurrentDirection;
    
    # we've exited an intersection - now see which
    # direction we are heading
    if( $CurrentDirection == INTERSECTION )
    {
	if( ( $PreviousDirection == DOWN ) ||
	    ( $PreviousDirection == UP ) )
	{
	    if( $Pos{x} < $Next->{x} )
	    { $CurrentDirection = RIGHT; }
	    else
	    { $CurrentDirection = LEFT; }
	}
	else
	{
	    if( $Pos{y} < $Next->{y} )
	    { $CurrentDirection = DOWN; }
	    else
	    { $CurrentDirection = UP; }
	}
    }

    
    if( $Next->{char} eq "+" )
    { $CurrentDirection = INTERSECTION;  }
    elsif( $Next->{char} =~ m/([a-zA-Z])/ )
    { push( @Consumed, $Next->{char} ); }

    $PreviousDirection = $CurrentTmp;
    %PreviousPos = ( 'x' => $Pos{x}, 'y' => $Pos{y} );
    $Pos{x} = $Next->{x};
    $Pos{y} = $Next->{y};
    $Steps++;
}


print "order is:", join("", @Consumed ), "\n";
print "steps are $Steps\n";


# consume the next non space character.
# Current is the current position we are at ( x,y )
# Previous is the previous position.  we check that we arent backtracking
# PossibleNext is an array of offsets ( x,y ) that we should apply to current pos, to find the next char
sub consume
{
    my ( $Current, $Previous, $PossibleNext ) = @_;
    foreach my $Possible( @$PossibleNext )
    {
	my ( $NextX, $NextY ) = ( $Current->{x} + $Possible->{x}, $Current->{y} + $Possible->{y} );
	if( ( $Previous->{x} == $NextX ) && ( $Previous->{y} == $NextY ) )
	{ next; }
	my $NextChar = $Matrix[ $NextY ]->[ $NextX ];
	if( defined( $NextChar ) && ( $NextChar ne " " ) )
	{ return { 'char' => $NextChar, 'x' => $NextX, 'y' => $NextY }; }
    }

    # nothing left to consume
    return undef;

}

