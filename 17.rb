#!/usr/bin/env ruby


def part1( iterations, step_size )

  spinlock = []
  spinlock[0] = 0
  current_size = 1
  current_position = 0

  for counter in 1..iterations
  
    next_position = (( current_position + step_size ) % current_size ) + 1
    spinlock.insert( next_position, counter )
    current_size = current_size + 1
    current_position = next_position
  end
  
  return spinlock[next_position+1]
  
end


def part2( iterations, step_size )

  current_size = 1
  current_position = 0
  after_zero = 0
  
  for counter in 1..iterations
  
    next_position = (( current_position + step_size ) % current_size ) + 1
    if next_position == 1
      after_zero = counter
    end
    
    current_size = current_size + 1
    current_position = next_position
  end
  
  return after_zero
  
end


p "part1: #{part1( 2017, 316 )}"
p "part1: #{part2( 50_000_000, 316 )}"
