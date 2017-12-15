#include <iostream>
#include <list>

using namespace std;

int part1( int AFactor, int BFactor, long long A, long long B, int Iterations )
{
  int Matches = 0;
  for( int i = 0; i < Iterations; i++ )
    {
      A = ( A * AFactor ) % 2147483647;
      B = ( B * BFactor ) % 2147483647;

      if( ( A & 0xFFFF ) == ( B & 0xFFFF ) )
	{ Matches++; }
    }
  return Matches;
}


int part2( int AFactor, int BFactor, long long A, long long B, int Iterations )
{
  int Matches = 0;
  int AMultiple = 4, BMultiple = 8;
  list<long long> AList, BList;
  int Compares = 0;
  
  for( int i = 0; Compares < Iterations; i++ )
    {
      A = ( A * AFactor ) % 2147483647;
      if( ! ( A % AMultiple ) )
	{ AList.push_back( A ); }
      
      B = ( B * BFactor ) % 2147483647;
      if( ! ( B % BMultiple ) )
	{ BList.push_back( B ); }

      while( AList.size() && BList.size() )
	{
	  if( ( AList.front() & 0xFFFF ) == ( BList.front() & 0xFFFF ) )
	    { Matches++; }

	  AList.pop_front(), BList.pop_front();
	  Compares++;
	}
    }  
  return Matches;
}


int main( int argc, char **argv )
{

  unsigned long long AFactor = 16807,
    BFactor = 48271,
    A = atoi( argv[1] ),
    B = atoi( argv[2] ),
    Iterations1 = atoi( argv[3] ),
    Iterations2 = atoi( argv[4] );


  cout << "part 1 Matches:" << part1( AFactor, BFactor, A, B, Iterations1 ) << endl;
  cout << "part 2 Matches:" << part2( AFactor, BFactor, A, B, Iterations2 ) << endl; 
}
