# frozen_string_literal: true
# typed: true

# for statements

for i in 1..5
  print i
end
puts

# each statements
(1..5).each do |i|
  print i
end

# time method
# 01234
5.times { |i| print i }
puts

# upto method
# 12345
1.upto(5) do |i|
  print i
end
puts

# downto method
# 98765
9.downto(5) do |i|
  print i
end
puts
