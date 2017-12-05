#include <iostream>
#include <vector>
#include <string>
#include <sstream>

using namespace std;

int main( int argc, char **argv )
{
  std::string input = argv[1];

  int Sum = 0;
  int Half = input.size() / 2;

  for( int i = 0; i < input.size(); i++ )
    {
      int AsInt = input[i] - '0';
      int CompareIndex = 0;
      if( ( i + Half ) <= ( input.size() - 1 ) )
      { CompareIndex = i + Half; }
      else
      {	CompareIndex = i + Half - input.size(); }

      if( AsInt == ( input[CompareIndex] - '0') )
      { Sum += AsInt; }
    }

  cout << Sum << endl;
  
}
