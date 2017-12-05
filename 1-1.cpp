#include <iostream>
#include <vector>
#include <string>
#include <sstream>

using namespace std;

int main( int argc, char **argv )
{
  std::string input = argv[1];

  bool First = true;
  int Previous = 0;
  int Sum = 0;

  for( std::string::const_iterator Iter = input.begin();
       Iter != input.end();
       ++Iter )
    {
      
      int AsInt = *Iter - '0';
      
      if( ! First )
	{
	  if( AsInt == Previous )
	  { Sum += AsInt; }
	}
      else
      { First = false; }

      Previous = AsInt ;
    }

  
  /// handle wraparound 
  if( Previous == ( input[0] - '0' ) )
  { Sum += Previous; }
  
  cout << Sum << endl;
  
}
