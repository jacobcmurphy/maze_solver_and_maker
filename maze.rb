# Author: Jacob Murphy

require 'matrix'
require_relative 'cell'

class Maze
	attr_accessor :wall_matrix

	def initialize x, y
		@num_rows = (x*2)+1
		@num_cols = (y*2)+1

		@wall_matrix = []
		@cell_matrix = Matrix.build(x, y) {|row, col| Cell.new(row, col) }
	end

	# TODO: add validity check
	def load str
		@wall_matrix = str.to_s.split('').each_slice(@num_cols).to_a

		# load the cell matrix
		@cell_matrix.each do |cell|
			cell.add_information @cell_matrix, @wall_matrix
		end
	end

	def display
		for i in 0...@num_rows
			for j in 0...@num_cols
				print_maze_piece i, j
			end
			print "\n"
		end
	end

	
	def solve begX, begY, endX, endY
		result = trace begX, begY, endX, endY
		if result.nil?
			puts "\nThere is no possible way to get to [#{endX}, #{endY}] from the starting position that you gave."
		else
			puts "There is a possible solution getting from to [#{begX}, #{begY}] to [#{endX}, #{endY}]."
		end
	end

	
	def trace begX, begY, endX, endY
		q = [] # to be used as a queue in a breadth-first search

		start_cell = @cell_matrix[begX, begY]
		q.push start_cell # enqueue

		solution = find_maze_path q, endX, endY

		start_cell.parent = nil
		if solution.nil?
			return false
		else
			print_path solution
		end
	end

	# TODO - make this
	# based off of http://www.mazeworks.com/mazegen/mazetut/
	def redesign
		options = [:top, :left, :right, :bottom]
		# reset all information in the cells
		@cell_matrix.each{ |cell| cell.reset }
		temp_options = temp_options.initialize_copy(options)

		option_num = rand(options.size)


	end


	private

	def print_maze_piece row, col
		if @wall_matrix[row][col].eql? '0'
			print ' '
		else
			if row%2 == 0
				if col%2 == 0
					print '+'
				else
					print '-'
				end
			else
				print '|'
			end
		end
	end

	def find_maze_path q, endX, endY
		dist = 0   # tracks how many steps currently into the maze we are
		# use a breadth first search to find the shortest path
		until q.empty?
			dist += 1
			current_cell = q.shift # dequeue
			current_cell.travelable_neighbors.each do |neighbor|
				unless neighbor.visited and neighbor.distance < dist
					q.push neighbor  # enqueue
					set_neighbor neighbor, current_cell, dist
					return neighbor if neighbor.coordinates[:x].to_i == endX.to_i and neighbor.coordinates[:y].to_i == endY.to_i
				end
			end
		end
		nil # return nil if no valid path is found
	end

	def set_neighbor neighbor, parent, dist
		neighbor.parent = parent
		neighbor.visited = true
		neighbor.distance = dist
	end

	def print_path end_cell
		path = []
		until end_cell.nil?
			path.unshift end_cell
			end_cell = end_cell.parent
		end

		path.each { |cell| print "[#{cell.coordinates[:x]}, #{cell.coordinates[:y]}] -> "}
		print "END"
	end

end


# TESTing code below
m= Maze.new 4, 4
m.load "111111111100010001111010101100010101101110101100000101111011101100000101111111111"

#puts m.wall_matrix.to_s
m.display

puts m.trace 0,0,3,3