#!/usr/bin/env ruby

in_garbage = false
in_skip = false
depth = 0
score = 0
chars_in_garbage = 0


ARGF.each_char do |char|
  
  if in_skip
    in_skip = false
    next
  end
  
  if in_garbage
    if char == '!'
      in_skip = true
    elsif char == '>'
      in_garbage = false
    else
      chars_in_garbage = chars_in_garbage + 1
    end
    next
  end
  
  case char
  when '{'
    depth = depth + 1
  when '}'
    score = score + depth
    depth = depth - 1
  when '<'
    in_garbage = true
  when '!'
    in_skip = true
  end

end

puts "score:#{score} chars_in_garbage:#{chars_in_garbage}"
   
