#!/usr/bin/env ruby


def doit( commands, source_array )

  data = Array.new( source_array )
  commands.split( "," ).each do |command|
    
    case command
        
    when /\As(\d+)/
      data.rotate!( data.size - $1.to_i )
      
    when /\Ax(\d+)\/(\d+)/
      data[$2.to_i], data[$1.to_i] = data[$1.to_i], data[$2.to_i] 
      
    when /\Ap(.+)\/(.*)/
        first = data.find_index{ |i| i == $1 }
        second = data.find_index{ |i| i == $2 }
        data[first], data[second] = $2,$1
        
    else
      p "unknown command: #{command}"
      exit(1)
      
    end

  end
  return data

end



input = ARGF.read
data = ( 'a'..'p' ).to_a

p "part 1: #{doit( input, data ).join("")}"

# hopefully this thing cycles. guessing they don't really want us to do 1B iterations
# let's find out where it cycles
result = Array.new( data )
max_iterations = 100_000

for counter in 1..max_iterations
  result = doit( input, result )
  if result == data
    break
  end
end

if counter == max_iterations
  p "no cycle :("
  exit(1)
end

#yay - there is a cycle. 
cycles_left_to_do = 1_000_000_000 % counter

result = Array.new( data )
for counter in 1..cycles_left_to_do
  result = doit( input, result )
end

p "part 2: #{result.join( "" )}"
