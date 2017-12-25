#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw/first_index/;
use List::Util qw/sum/;
use Clone 'clone';
    
my ( @Components, @Bridges );

my $Id = 0;
while( my $Line = <STDIN> )
{
    chomp( $Line );
    if( $Line =~ m|(.*)/(.*)| )
    {
	# component is defined by 
	#  A uniq id 
	#  A 'used' array, that keeps track of which ports have been used
	#  A 'types' array, that holds the types of this component
	my %Component = ( id => $Id, types => [ $1-'0', $2-'0' ], used => [] );
	push( @Components, \%Component );
	if( has_open_type( \%Component, my $Type = 0 ) )
	{
	    my $NewComponent = clone( \%Component );
	    mark_used( $NewComponent, $Type );
	    push( @Bridges, { used => { $Id => 1 }, components => [ $NewComponent ] } );
	}
    }
    else
    { die "bad line\n"; }
    $Id++;
}

find_bridges( \@Bridges, my $Depth = 1 );
#print_bridges( \@Bridges );

my $MaxStrength = undef;
my %MaxStrengthByLength;

foreach my $Bridge( @Bridges )
{
    my $Strength = count_strength( $Bridge );
    my $Length = scalar( @{$Bridge->{components}} );

    if( ! defined( $MaxStrengthByLength{$Length} ) ||
	( $MaxStrength > $MaxStrengthByLength{$Length} ) )
    { $MaxStrengthByLength{$Length} = $Strength; }
    
    if( ! defined( $MaxStrength ) || ( $Strength > $MaxStrength ) )
    { $MaxStrength = $Strength; }
}

my @Keys = sort { $a <=> $b } keys %MaxStrengthByLength;
my $MaxKey = $Keys[scalar( @Keys)-1];

print "max strength: $MaxStrength\n";
print "max strength of longest: $MaxStrengthByLength{$MaxKey}\n";

 
sub count_strength
{
    my $Bridge = shift;
    my $Strength = 0;
    foreach my $Component( @{$Bridge->{components}} )
    { $Strength += sum( @{$Component->{types}} ); }
    return $Strength;
}

sub find_bridges
{
    my ( $Bridges, $Depth ) = @_;
    my $FoundNew = 0;
    
    foreach my $Bridge( @{$Bridges} )
    {
	# bride has already hit its terminal point
	if( scalar( @{$Bridge->{components}} ) != $Depth )
	{ next; }
	
	my $BridgeTipComponent = $Bridge->{components}->[$Depth-1];
	my $OpenType = get_open_type( $BridgeTipComponent );

	# see if any of the pairs mate with the existing termainal points
	foreach my $Component( @Components )
	{
	    if( defined( $Bridge->{used}->{$Component->{id}} ) )
	    { next; }
	    
	    if( ! has_open_type( $Component, $OpenType ) )
	    { next; }
	    
	    $FoundNew = 1;
	    
	    # copy the bridge to a new bridge.  The existing bridge
	    # itself will become a terminal valid bridge
	    my $NewBridge = clone( $Bridge );
	    my $NewComponent = clone( $Component );
	    mark_used( $NewComponent, $OpenType );
	    $NewBridge->{used}->{$Component->{id}} = 1;
	    push( @{$NewBridge->{components}}, $NewComponent );
	    push( @$Bridges, $NewBridge );
	}
    }
 
    if( $FoundNew )
    {
	print "doing new depth after $Depth\n";
	find_bridges( $Bridges, $Depth + 1 );  
    }
}


# given a coponent, mark one of its ports of type Type,
# as used   
sub mark_used
{
    my ( $Component, $Type ) = @_;
    push( @{$Component->{used}}, $Type );
}

# returns the first found open type
sub get_open_type
{
    my ( $Component ) = @_;
    my @UsedCopy = @{$Component->{used}};
    foreach my $Type( @{$Component->{types}} )
    {
	my $Index = first_index { $_ == $Type } @UsedCopy;
	if( $Index == -1 )
	{ return $Type; }

	splice( @UsedCopy, $Index, 1 );
    }

    print_bridges( \@Bridges );
    print "didnt find open port for:" . Dumper( $Component );
    exit(1);
}
	
# given a component, determines if there is an open port
# of a specific type.  returns non-zero if true, else, zero
sub has_open_type
{
    my ( $Component, $Type ) = @_;
    my $CountOfType = grep { $_ == $Type } @{$Component->{types}};
    my $UsedOfType = grep { $_ == $Type } @{$Component->{used}};
    return ( $CountOfType - $UsedOfType );
}

sub print_bridges
{
    my $Bridges = shift;
    foreach my $Bridge( @{$Bridges} )
    {
	foreach my $Component( @{$Bridge->{components}} )
	{ print "$Component->{types}->[0]/$Component->{types}->[1] ->"; }
	print "\n";
    }
    print "\n\n";

}
