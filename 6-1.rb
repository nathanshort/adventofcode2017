#!/usr/bin/ruby

# input was 4 1 15 12 0 9 9 5 5 8 7 3 14 5 12 3

def cycle_count( banks )

  signatures = {}
  iteration = 0
  
  while true
    
    signature = banks.to_s
    
    if signatures.key?( signature )
      break;
    end
    
    iteration = iteration + 1
    signatures[signature] = 1;
    
    max_index = banks.index( banks.max )
    count_at_max_bank = banks[max_index]
    banks[max_index] = 0
    
    for i in 1..count_at_max_bank
      current_index = ( i + max_index ) % banks.size
      banks[current_index] = banks[current_index] + 1
    end

  end

   [ iteration, banks ]
  
end


banks = ARGV.map { |x| x.to_i }
iterations, banks = cycle_count banks
p iterations


