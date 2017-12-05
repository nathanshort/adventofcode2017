#include <iostream>
#include <map>

using namespace std;

#define ARRAY_SIZE(arr) ( sizeof(arr)/sizeof(arr[0]) )

struct Point
{
  Point( int xx, int yy ):
    x( xx ), y( yy )
  {}
  
  int x,y;
};

/// used as comparator for Points, when used in a map 
struct PointCompare
{
  bool operator() (const Point& lhs, const Point& rhs) const
  { return (lhs.x < rhs.x) || ((lhs.x == rhs.x) && (lhs.y < rhs.y)); }
};


int main( int argc, char **argv )
{
  int TargetNumber = atoi( argv[1] );
  
  enum Directions
  {
    eRight = 0, eUp, eLeft, eDown,
  };
  
  Directions AllDirections[] = { eRight, eUp, eLeft, eDown };
  int CurrentDirection = eRight;

  int CurrentX = 0, CurrentY = 0;

  int StepsPerIteration = 1;
  int IterationCount = 0;
  int MaxIterationsPer = 2;
  int CurrentStep = 0;

  /// lookup table for Point -> value at Point
  map< Point, int, PointCompare > TheMap;

  /// value 1 at origin. we'll calc the rest
  Point Origin( 0, 0 );
  TheMap.insert( make_pair( Origin, 1 ) );
  
  for( int i = 2; true ; i++ )
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

      Point MyPoint( CurrentX, CurrentY );

      Point Comparisons[] = { 
	Point( MyPoint.x - 1, MyPoint.y + 1 ),
	Point( MyPoint.x - 1, MyPoint.y ),
	Point( MyPoint.x - 1, MyPoint.y - 1 ),
	Point( MyPoint.x, MyPoint.y - 1 ),
	Point( MyPoint.x + 1, MyPoint.y - 1 ),
	Point( MyPoint.x + 1, MyPoint.y ),
	Point( MyPoint.x + 1, MyPoint.y + 1 ),
	Point( MyPoint.x, MyPoint.y + 1 ) };

      int TheValue = 0;

      for( int p = 0; p < ARRAY_SIZE( Comparisons ); p++ )
	{
	  map< Point, int>::const_iterator AdjacentPoint = TheMap.find( Comparisons[p] );
	  if( AdjacentPoint != TheMap.end() )
	    { TheValue += AdjacentPoint->second; }
	}

      TheMap.insert( make_pair( MyPoint, TheValue ) );

      cout << i << "(" << CurrentX << "," << CurrentY << ")"
	   <<  " -> " << TheValue << endl;

      if( TheValue > TargetNumber )
      { break;	}
      
	    
      /// decide if we need to change direction
      if( ++IterationCount == StepsPerIteration )
	{
	  CurrentDirection = AllDirections[ ( CurrentDirection + 1 ) % ARRAY_SIZE( AllDirections ) ];
	  IterationCount = 0;
	}

      if( ++CurrentStep == ( MaxIterationsPer * StepsPerIteration ) )
	{
	  StepsPerIteration++;
	  IterationCount = 0;
	  CurrentStep = 0;
	}
    }
}
