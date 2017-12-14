#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $Input = $ARGV[0];

my $Count = 0;
my @Rows;

for( my $i = 0; $i < 128; $i++ )
{
    my $Rowdata = "${Input}-${i}";
    my $Hash = Hash( $Rowdata );

    my @RowItems = split( //, $Hash );
    push @Rows, \@RowItems;

    foreach my $x( @RowItems )
    { $Count++ if ( $x eq "1" ); }
}


my @Regions;
my $RegionNumber = 1;

for( my $RowNum = 0; $RowNum < scalar( @Rows ); $RowNum++ )
{
    for( my $ColumnNum = 0; $ColumnNum < scalar( @{$Rows[$RowNum]} ); $ColumnNum++ )
    {
	if( markregion( $RowNum, $ColumnNum, $RegionNumber ) )
	{ $RegionNumber++; }
    }
}

# regionnumber was incremented above, but last value will not be used
$RegionNumber--;


print "UsedSquares:$Count Regions:$RegionNumber\n";


# returns 1 on a marked region, else undef
sub markregion
{
    my ( $Row, $Col, $RegionNumber ) = @_;
    
    # return on oob
    if( ( $Row < 0 ) || ( $Row > ( scalar( @Rows) - 1 ) ) ||
	( $Col < 0 ) || ( $Col > scalar( @{$Rows[$Row]} - 1 ) ) )
    { return; }

    # if its already been marked as a region, then its not a new region
    if( ( $Rows[$Row]->[$Col] eq "1" ) &&
	! defined( $Regions[$Row]->[$Col] ) )
    {
	# mark the ( $Row, $Col ) with the current region number
	# then look for adjacent blocks to the right, bottom, left, and top
	$Regions[$Row]->[$Col] = $RegionNumber;
	markregion( $Row, $Col + 1, $RegionNumber );
	markregion( $Row + 1, $Col, $RegionNumber );
	markregion( $Row, $Col - 1, $RegionNumber );
	markregion( $Row - 1, $Col, $RegionNumber );

	return 1;
    }
    else
    { return undef; }

}


# returns the knothash as a binary string ( ie, "10001001110000..." )
sub Hash
{
    my @Lengths = map { ord $_ } split( //, shift );
    @Lengths = ( @Lengths, 17, 31, 73, 47, 23 );
    
    my @Inputs = 0..255;
    
    my $CurrentPos = 0;
    my $SkipSize = 0;
    
    
    for( my $Round = 0; $Round < 64; $Round ++ )
    {
	foreach my $Length( @Lengths )
	{
	    my @SubList;
	    for( my $i = 0; $i < $Length; $i++ )
	    {
		my $Index = ( $CurrentPos + $i ) % scalar( @Inputs );
		push( @SubList, $Inputs[$Index] );
	    }
	    
	    my( $SpotsBack, $SpotsFront ) = ( 0,0 );
	    if( ( $CurrentPos + $Length ) >= scalar( @Inputs ) )
	    {
		$SpotsBack = scalar( @Inputs ) - $CurrentPos;
		$SpotsFront = $Length - $SpotsBack;
	    }
	    else
	    { $SpotsBack = $Length; }
	    
	    my @Reversed = reverse( @SubList );
	    
	    if( $SpotsBack )
	    { splice( @Inputs, $CurrentPos, $SpotsBack, @Reversed[ 0..($SpotsBack - 1 )] ); }
	    
	    if( $SpotsFront )
	    { splice( @Inputs, 0, $SpotsFront, @Reversed[ ( $SpotsBack )..( $Length - 1 )] ); }
	    
	    $CurrentPos = ( $CurrentPos + $Length + $SkipSize++ ) % scalar( @Inputs );
	}
    }
    
    my @Xors;
    for my $Offset ( 0..15 )
    {
	my @ToXor = @Inputs[ ( $Offset * 16 )..( ( ( $Offset + 1 ) * 16 ) - 1 ) ];
	my $Partial = 0;
	foreach my $To( @ToXor )
	{ $Partial = $Partial ^ $To; }
	push( @Xors, $Partial );
    }
    
    my $Binary = "";
    foreach my $Xor( @Xors )
    { $Binary .= sprintf( "%08b", $Xor ); }
    
    return $Binary;

}
