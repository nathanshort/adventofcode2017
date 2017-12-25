#include <stdlib.h>
#include <iostream>

using namespace std;

int main( int argc, char ** argv )
{
  int  a = 0, b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0;
  
  a = atoi( argv[1] );
  b = 99;
  c = b;

  if( a != 0 )
  {
    b = b * 100;
    b = b + 100000;
    c = b;
    c = c + 17000;
  }

  while( 1 )
  {
    f = 1;
    d = 2;
    
    do
    {
      e = 2;

      /// optimize out slow inner loop from assembly
      if( !( b % d ) )
      { f = 0; }
      
      d = d + 1;
      g = d;
      g = g - b;
    }
    while( g != 0 );
      
    if( f == 0 )
    { h = h + 1; }
    
    g = b;
    g = g - c;
    if( g == 0 )
    {
      cout << h << endl;
      exit(0);
    }
      
    b = b + 17;
  }
}
