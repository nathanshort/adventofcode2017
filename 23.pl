#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my ( %InsCount, %Registers );

my %Ops =
    (
     'set' => sub 
     {
	 my ( $x, $y ) = @_;
	 my $Value = ( $y =~ m/\d/ ) ? $y : $Registers{$y};
	 $Registers{$x} = $Value;
	 return 1;
     },
     'sub' => sub {
	 my ( $x, $y ) = @_;
	 my $Value = ( $y =~ m/\d/ ) ? $y : $Registers{$y};
	 $Registers{$x} -= $Value;
	 return 1; 
     },
     'mul' => sub {
	 my ( $x, $y ) = @_;
	 my $Value = ( $y =~ m/\d/ ) ? $y : $Registers{$y};
	 $Registers{$x} *= $Value;
	 return 1; 
     },
     'jnz' => sub {
	 my ( $x, $y ) = @_;
	 my $Target = ( $x =~ m/\d/ ) ? $x : $Registers{$x};
	 my $Value = ( $y =~ m/\d/ ) ? $y : $Registers{$y};
	 if( $Target != 0 )
	 { return $Value; }
	 return 1;
     },
    );


sub run_program
{
    my ( $Instructions, $Debug, $InsCount ) = @_;
    my ( $Counter, $Pc ) = ( 0, 0 );
    if( ! defined( $InsCount ) )
    { $InsCount = 100000; };

    
    for( $Pc = 0; ( $Pc >= 0 ) && ( $Pc < scalar( @$Instructions ) ) &&
	 $Counter++ < $InsCount; )
    {
	my $Instruction = $Instructions->[$Pc];
	if( $Instruction =~ m/^([^\s]+) ([^\s]+)(?: ([^\s]*))?$/ )
	{ $Pc += $Ops{$1}($2,$3); }
	else
	{ die "unknown line $Instruction\n"; }
	$InsCount{$1}++;
    }
}

my @Instructions = ();
while( my $Line = <STDIN> )
{
    chomp( $Line );
    push( @Instructions, $Line );
}


for my $x( 'a'..'h')
{ $Registers{$x} = 0; }
run_program( \@Instructions, 0 );
print "mul count: $InsCount{mul}\n";
