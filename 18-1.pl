#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my %Registers = ();
my $LastSound = undef;
my $Recovery = undef;

my %Ops =
    (
     'snd' => sub { 
	 $LastSound = $Registers{$_[0]}; 
	 return 1; 
     },
     'set' => sub 
     {
	 my ( $x, $y ) = @_;
	 my $Value = ( $y =~ m/\d/ ) ? $y : $Registers{$y};
	 $Registers{$x} = $Value;
	 return 1; 
     },
     'add' => sub {
	 my ( $x, $y ) = @_;
	 my $Value = ( $y =~ m/\d/ ) ? $y : $Registers{$y};
	 $Registers{$x} += $Value;
	 return 1; 
     },
     'mul' => sub {
	 my ( $x, $y ) = @_;
	 my $Value = ( $y =~ m/\d/ ) ? $y : $Registers{$y};
	 $Registers{$x} *= $Value;
	 return 1; 
     },
     'mod' => sub { 
	 my ( $x, $y ) = @_;
	 my $Value = ( $y =~ m/\d/ ) ? $y : $Registers{$y};
	 $Registers{$x} %= $Value; 
	 return 1; 
     },
     'rcv' => sub {
	 if( $Registers{$_[0]} != 0 )
	 { $Recovery = $LastSound; }
	 return 1;
     },
     'jgz' => sub {
	 my ( $x, $y ) = @_;
	 my $Target = ( $x =~ m/\d/ ) ? $x : $Registers{$x};
	 my $Value = ( $y =~ m/\d/ ) ? $y : $Registers{$y};
	 if( $Target > 0 )
	 { return $Value; }
	 return 1;
     },
    );

my @Instructions = ();

while( my $Line = <STDIN> )
{
    chomp( $Line );
    push( @Instructions, $Line );
}

my $Pc = 0;
for( $Pc = 0; ( $Pc >= 0 ) && ( $Pc < scalar( @Instructions ) ) && ( ! defined( $Recovery ) ); )
{
    my $Instruction = $Instructions[$Pc];
    if( $Instruction =~ m/^([^\s]+) ([^\s]+)(?: ([^\s]*))?$/ )
    { $Pc += $Ops{$1}($2,$3); }
    else
    { die "unknown line $Instruction\n"; }
}

print "Recovery freq: $Recovery\n";
