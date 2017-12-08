#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my %Registers;

my %Ops =
    (
     "inc" => sub{ $Registers{$_[0]} += $_[1]; },
     "dec" => sub{ $Registers{$_[0]} -= $_[1]; },
    );


my %Compares =
    (
     ">" => sub{ return $Registers{$_[0]} > $_[1] },
     "<" => sub{ return $Registers{$_[0]} < $_[1] },
     "==" => sub{ return $Registers{$_[0]} == $_[1] },
     ">=" => sub{ return $Registers{$_[0]} >= $_[1] },
     "<=" => sub{ return $Registers{$_[0]} <= $_[1] },
     "!=" => sub{ return $Registers{$_[0]} != $_[1] },
    );


my $Highest = undef;
while( my $Line = <STDIN> )
{
    chomp( $Line );

    #b inc 5 if a > 1
    if( $Line =~ m/^([^\s]+) ([^\s]+) ([^\s]+) if ([^\s]+) ([^\s]+) ([^\s]+)/ )
    {
	my( $TargetReg, $TargetOp, $TargetOpValue, $CompareReg, $Comparison, $ComparisonTarget )
	    = ( $1, $2, $3, $4, $5, $6 );

	$Registers{$TargetReg} = 0 if ! defined( $Registers{$TargetReg} );
	$Registers{$CompareReg} = 0 if ! defined( $Registers{$CompareReg} );
	
	$Ops{ $TargetOp}( $TargetReg, $TargetOpValue ) 
	    if $Compares{$Comparison}( $CompareReg, $ComparisonTarget );

	$Highest = $Registers{$TargetReg} if ( ! defined( $Highest ) || $Registers{$TargetReg} > $Highest ); 
    }
    else
    { print "NO MATCH $Line\n"; }
   
}

my @Values = sort { $Registers{$b} <=> $Registers{$a} } keys %Registers;
print "Highest Ever:$Highest  Highest At End: {$Registers{$Values[0]}}\n";
