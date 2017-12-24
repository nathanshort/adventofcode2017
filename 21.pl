#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);

# decompose new matrices into resulting new patterns
sub decompose
{
    my $Grids = shift;

    my $Size = ( scalar( @$Grids ) == 1 ) ?
	( scalar( @{$Grids->[0] } ) ) :
	( sqrt( scalar( @{$Grids} ) * 
		( scalar( @{$Grids->[0]}) ) * 
		( scalar( @{$Grids->[0]->[0]} ) ) ) );
    
    my @RawMatrix;
    my ( $RowOffset, $RowOffsetFactor ) = ( 0, 0 );
    $RowOffsetFactor = scalar( @{$Grids->[0]->[0]} );

    # first build up the master pattern array, which we will
    # break apart into sub-patterns later
    for( my $Rule = 0; $Rule < scalar( @$Grids ); $Rule++ )
    {
	for( my $RuleItem = 0; $RuleItem < scalar( @{$Grids->[$Rule]} ); $RuleItem++ )
	{
	    my $AdjustedRow = $RuleItem + $RowOffset;
	    if( ! defined( $RawMatrix[$AdjustedRow] ) )
	    { $RawMatrix[$AdjustedRow] = (); }
	    push( @{$RawMatrix[$AdjustedRow]}, @{$Grids->[$Rule]->[$RuleItem]} );
	}
	if( $Rule && ( !( ( $Rule + 1 ) % ( $Size / $RowOffsetFactor ) ) ) )
	{ $RowOffset = $RowOffset + $RowOffsetFactor; }
    }

    
    my @NewGrids;
    if( ! ( $Size % 2 ) )
    {
	my ( $RowOffset, $ColumnOffset ) = ( 0, 0 );
	for( my $i = 0; $i < ( $Size * $Size ) / 4; $i++ )
	{
	    my @SubMatrix = ( [ $RawMatrix[$RowOffset]->[$ColumnOffset],
				$RawMatrix[$RowOffset]->[$ColumnOffset+1] ],
			      [ $RawMatrix[$RowOffset+1]->[$ColumnOffset],
				$RawMatrix[$RowOffset+1]->[$ColumnOffset+1] ] );
	    push( @NewGrids, \@SubMatrix );

	    $ColumnOffset = ( $ColumnOffset + 2 ) % $Size;
	    if( $ColumnOffset == 0 )
	    { $RowOffset += 2; }
	}
    }
    else
    {
	my ( $RowOffset, $ColumnOffset ) = ( 0, 0 );
	for( my $i = 0; $i < ( $Size * $Size ) / 9; $i++ )
	{
	    # gotta be a better way to do this??
	    my @SubMatrix = ( [ $RawMatrix[$RowOffset]->[$ColumnOffset],
				$RawMatrix[$RowOffset]->[$ColumnOffset+1],
				$RawMatrix[$RowOffset]->[$ColumnOffset+2] ],
			      [ $RawMatrix[$RowOffset+1]->[$ColumnOffset],
				$RawMatrix[$RowOffset+1]->[$ColumnOffset+1],
				$RawMatrix[$RowOffset+1]->[$ColumnOffset+2] ],
			      [ $RawMatrix[$RowOffset+2]->[$ColumnOffset],
				$RawMatrix[$RowOffset+2]->[$ColumnOffset+1],
				$RawMatrix[$RowOffset+2]->[$ColumnOffset+2] ] );
	    push( @NewGrids, \@SubMatrix );

	    $ColumnOffset = ( $ColumnOffset + 3 ) % $Size;
	    if( $ColumnOffset == 0 )
	    { $RowOffset += 3; }
	}
    }
    return \@NewGrids;    
}

# compares two, 2D arrays
sub matrix_equal
{
    my ( $A, $B ) = @_;
    if( scalar( @$A ) != scalar( @$B ) )
    { return 0; }

    for( my $R = 0; $R < scalar( @$A ); $R++ )
    {
	if( !( $A->[$R] ~~ $B->[$R] ) )
	{ return 0; }
    }

    return 1;
}

# return the horizontal and vertical flip of a 2D array
sub flips
{
    my ( $InputMatrix ) = shift;
    my @OutputMatrices;
    
    my @FlippedVertical;
    for( my $Row = scalar( @$InputMatrix ) - 1; $Row >=0; $Row-- )
    {
	my @Columns = @{$InputMatrix->[$Row] };
	$FlippedVertical[scalar(@$InputMatrix) - $Row - 1 ] = \@Columns;
    }
    push( @OutputMatrices, \@FlippedVertical );


    my @FlippedHorizontal;
    for( my $Row = 0; $Row < scalar( @$InputMatrix); $Row++ )
    {
	my @Columns = reverse( @{$InputMatrix->[$Row]} );
	$FlippedHorizontal[$Row] = \@Columns;
    }
    push( @OutputMatrices, \@FlippedHorizontal );

    return @OutputMatrices;
}


# return the 90 deg rotation of a 2D array
sub rotate_90
{
    my ( $InputMatrix ) = shift;
    my @OutputMatrix;
    for( my $i = 0; $i < scalar( @$InputMatrix ); $i++) 
    {
        for( my $j = 0; $j < scalar( @$InputMatrix); $j++) 
	{
            $OutputMatrix[$i]->[$j] = 
		$InputMatrix->[ scalar( @$InputMatrix ) - $j - 1]->[$i];
        }
    }
    return \@OutputMatrix;
}


# return the passed in 2D array, plus all flips, rotations, and
# flips of rotations
sub me_and_rotations_and_flips
{
    my ( $Pattern ) = @_;
    my @Matrices;

    my $BaseMatrix = $Pattern;
    push( @Matrices, $BaseMatrix );
    push( @Matrices, flips( $BaseMatrix ) );
    
    my $Rotated = $BaseMatrix;
    for( my $i = 0; $i < 3; $i++ )
    {
	$Rotated = rotate_90( $Rotated );
	push( @Matrices, $Rotated );
	push( @Matrices, flips( $Rotated ) );
    }

    return @Matrices;
}


my @Rules;
while( my $Line = <STDIN> )
{
    chomp( $Line );
    if( $Line =~ m/^(.*) => (.*)$/)
    {
	my @Matches;
	foreach my $Row( split(/\//, $1 ) )
	{
	    my @Columns = split( //, $Row );
	    push( @Matches, \@Columns );
	}
   
	my @Results;
	foreach my $Row( split(/\//, $2 ) )
	{
	    my @Columns = split( //, $Row );
	    push( @Results, \@Columns );
	}
	
	my %Rule = ( matches => \@Matches, results => \@Results );
	push( @Rules, \%Rule );
    }
    else
    { die "bad line $Line\n"; }
}

my @Grids = ( [ [ '.','#','.'], ['.','.','#'],['#','#','#'] ] );


for( my $Iteration = 0; $Iteration < $ARGV[0]; $Iteration++ )
{
    print "Iteration: $Iteration\n";
    
    my @ResultingGrids = ();
    for( my $G = 0; $G < scalar( @Grids ); $G++ )
    {
	my $Matched = 0;
	my $Grid = $Grids[$G];    
	my @Matrices = me_and_rotations_and_flips( $Grid );

	for( my $M = 0; ( ! $Matched ) && ( $M < scalar( @Matrices ) ); $M++ )
	{
	    my $Matrix = $Matrices[$M];
	    for( my $R = scalar( @Rules - 1 ); 
		 ( ! $Matched ) && ( $R >= 0 ); $R-- )
	    {
		my $Rule = $Rules[$R];
		if( matrix_equal( $Matrix, $Rule->{matches} ) )
		{
		    $Matched = 1;
		    push( @ResultingGrids, $Rule->{results} );
		}
	    }
	}
	if( ! $Matched )
	{ 
	    print "failed to match" . Dumper( $Grid );
	    exit(1);
	}
    }
    
    my $New = decompose( \@ResultingGrids );
    @Grids = @$New;
}


my $Count = 0;
foreach my $Grid( @Grids )
{
    foreach my $Row( @$Grid )
    {
	foreach my $Element( @$Row )
	{ $Count++ if $Element eq "#"; }
    }
}

print "Count: $Count\n";


