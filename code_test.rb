# Author: Jacob Murphy

require_relative 'maze'

# make a new 4x4 maze
m= Maze.new 4, 4

# use this string to load the given maze
m.load "111111111100010001111010101100010101101110101100000101111011101100000101111111111"
# output an ascii display of the maze
m.display

# checks if Maze m can be solved
m.solve 0,0,3,3

# print ou the steps to solve the maze
puts "\n\n"
m.trace 0,0,3,3
puts "\n\n"

# make a new 10x10 maze
m.redesign 10, 10

# output an ascii display of the new maze
m.display

# output the steps to get from [0,0] to [9,9] in the new maze
puts m.trace 0,0,9,9