#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my %Registers = ( 'p0' => { 'p' => 0 }, 
		  'p1' => { 'p' => 1 } );

my @Programs = ( 'p0', 'p1' );


my ( %ReceiveQueue, # array ready to be received from
     %SendCounts, # counts of sends per program
     %Pc, # program counter per program
     %WaitingOnReceive # 0/1 indicating that the PC is stuck waiting on receive
    );


foreach my $P( @Programs )
{
    $ReceiveQueue{$P} = [];
    $SendCounts{$P} = 0;
    $Pc{$P} = 0;
    $WaitingOnReceive{$P} = 0;
}


# each op returns the PC increment
my %Ops =
    (
     'snd' => sub {
	 my ( $program, $value ) = @_;
	 my $Value = ( $value =~ m/\d/ ) ? $value : $Registers{$program}{$value};
	 my $Target = ( $program eq 'p1' ) ? 'p0' : 'p1';
	 push( @{$ReceiveQueue{$Target}}, $Value );
	 $SendCounts{$program}++;
	 return 1; 
     },
     'rcv' => sub {
	 my ( $program, $value ) = @_;
	 if( scalar( @{$ReceiveQueue{$program}} ) )
	 {
	     $Registers{$program}{$value} = shift( @{$ReceiveQueue{$program}} );
	     return 1;
	 }
	 return 0;
     },
     'set' => sub 
     {
	 my ( $program, $x, $y ) = @_;
	 my $Value = ( $y =~ m/\d/ ) ? $y : $Registers{$program}{$y};
	 $Registers{$program}{$x} = $Value;
	 return 1; 
     },
     'add' => sub {
	 my ( $program, $x, $y ) = @_;
	 my $Value = ( $y =~ m/\d/ ) ? $y : $Registers{$program}{$y};
	 $Registers{$program}{$x} += $Value;
	 return 1; 
     },
     'mul' => sub {
	 my ( $program, $x, $y ) = @_;
	 my $Value = ( $y =~ m/\d/ ) ? $y : $Registers{$program}{$y};
	 $Registers{$program}{$x} *= $Value;
	 return 1; 
     },
     'mod' => sub { 
	 my ( $program, $x, $y ) = @_;
	 my $Value = ( $y =~ m/\d/ ) ? $y : $Registers{$program}{$y};
	 $Registers{$program}{$x} %= $Value; 
	 return 1; 
     },
     'jgz' => sub {
	 my ( $program, $x, $y ) = @_;
	 my $Target = ( $x =~ m/\d/ ) ? $x : $Registers{$program}{$x};
	 my $Value = ( $y =~ m/\d/ ) ? $y : $Registers{$program}{$y};
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


while( ( $Pc{p0} >= 0 ) && ( $Pc{p1} >= 0 ) &&
       ( $Pc{p0} < scalar( @Instructions ) ) &&
       ( $Pc{p1} < scalar( @Instructions ) ) &&
       ( ( ! $WaitingOnReceive{'p0'} ) || ( ! $WaitingOnReceive{'p1'} ) ) )
{
    foreach my $Program( @Programs )
    {
	my $Instruction = $Instructions[$Pc{$Program}];
	if( $Instruction =~ m/^([^\s]+) ([^\s]+)(?: ([^\s]*))?$/ )
	{
	    my $PcIncrement = $Ops{$1}($Program, $2, $3);
	    if( $PcIncrement )
	    { $Pc{$Program} += $PcIncrement; }
	    else
	    { $WaitingOnReceive{$Program} = 1; }
	}
	else
	{ die "unknown line $Instruction\n"; }
    }
}

print "p1 sends: $SendCounts{p1}\n";
