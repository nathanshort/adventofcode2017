#include <iostream>
#include <map>
#include "stdlib.h"

using namespace std;

int main( int argc, char **argv )
{

  int TargetNumber = atoi( argv[1] );
  
  enum Directions
  {
    eRight = 0, eUp, eLeft, eDown,
  };

  Directions AllDirections[] = { eRight, eUp, eLeft, eDown };
  int CurrentDirection = eRight;

  /// 0 is at (0,0)
  int CurrentX = 0, CurrentY = 0;

  /// basicaly we do 2 iterations of MovesPerIteration
  /// ie, move 1, 2 times.  then move 2, 2 times.
  /// then move 3, 2 times. etc...
  int MovesPerIteration = 1;
  int IterationCount = 0;
  int MaxIterationsPer = 2;
  int CurrentStep = 0;

  /// walk the cycle, finding the (x,y) for TargetNumber
  for( int i = 2; i <= TargetNumber; i++ )
    {
      switch( CurrentDirection )
	{
	case eRight:
	  CurrentX++;
	  break;
	case eUp:
	  CurrentY++;
	  break;
	case eLeft:
	  CurrentX--;
	  break;
	case eDown:
	  CurrentY--;
	  break;
	}      

      /// decide if we need to change direction
      if( ++IterationCount == MovesPerIteration )
	{
	  /// array size AllDirections == 4
	  CurrentDirection = AllDirections[ ( CurrentDirection + 1 ) % 4 ];
	  IterationCount = 0;
	}

      /// decide if we need to up the MovesPerIteration, as we have done our 2 iterations
      /// for this step count
      if( ++CurrentStep == ( MaxIterationsPer * MovesPerIteration ) )
	{
	  MovesPerIteration++;
	  IterationCount = 0;
	  CurrentStep = 0;
	}
    }

  int ManhattanDistance =  abs( CurrentX ) + abs( CurrentY );
  cout << TargetNumber << ":" << ManhattanDistance << endl;
}
