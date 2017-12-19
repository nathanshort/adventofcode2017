#!/usr/bin/perl

use strict;
use warnings;
use List::MoreUtils qw/first_index/;
use Data::Dumper;

use constant { VERTICAL => 0, HORIZONTAL => 1, INTERSECTION => 2, };
    

my @Matrix;
my $RowCnt = 0;
while( my $Line = <STDIN> )
{
    chomp( $Line );
    my @Chars = split( //, $Line );
    push( @Matrix, \@Chars );
}


# start out at the first pipe in the first row
my %Pos = ( y => 0, x => first_index { $_ eq "|" } @{$Matrix[0]} );
my %PreviousPos = ( y => 0, x => 0 );

my ( $CurrentDirection, $PreviousDirection ) = ( VERTICAL, VERTICAL );

# keep track of chars that were consumed
my @Consumed = ();

# how many non-space chars we've consumed
my $Steps = 1;

while( 1 )
{
    my @PossibleNexts;

    # if we are going in a direction previously, keep going in that direction
    # else if we are at a intersection, then we'll change directions
    if( $CurrentDirection == VERTICAL || ( $CurrentDirection == INTERSECTION && $PreviousDirection != VERTICAL ) )
    { @PossibleNexts =  ( { x => 0, y => 1 }, { x => 0, y => -1 } ); }
    elsif( $CurrentDirection == HORIZONTAL  || ( $CurrentDirection == INTERSECTION && $PreviousDirection != HORIZONTAL ) )
    { @PossibleNexts = ( {  x => -1, y => 0 }, { x => 1, y => 0 } ); }

    my $Next = consume( \%Pos, \%PreviousPos, \@PossibleNexts );
    if( ! defined( $Next ) )
    { last; }

    my $CurrentTmp = $CurrentDirection;
    
    # we've exited an intersection - now see which
    # direction we are heading
    if( $CurrentDirection == INTERSECTION )
    {
	if( $PreviousDirection == VERTICAL )
	{ $CurrentDirection = HORIZONTAL; }
	else
	{ $CurrentDirection = VERTICAL; }
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
