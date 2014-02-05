# Author: Jacob Murphy

require 'matrix'
require_relative 'cell'

class Maze
	attr_accessor :wall_matrix

	def initialize r, c
		@num_rows = r
		@num_cols = c

		@wall_matrix = []
		@cell_matrix = Matrix.build(@num_rows, @num_cols) {|row, col| Cell.new(row, col) }
	end

	# TODO: add validity check
	def load str
		@wall_matrix = str.to_s.split('').each_slice(@num_cols*2 +1).to_a

		# load the cell matrix
		@cell_matrix.each do |cell|
			cell.add_information @cell_matrix, @wall_matrix
		end
	end

	def display
		for i in 0...@wall_matrix.size
			for j in 0...@wall_matrix[0].size
				print_maze_piece i, j
			end
			print "\n"
		end
	end

	
	def solve begR, begC, endR, endC
		result = trace begR, begC, endR, endC
		unless result.nil?
			puts "\nThere is a possible solution getting from to [#{begC}, #{begR}] to [#{endC}, #{endR}]."
		else
			puts "\nThere is no possible solution to get from [#{begC}, #{begR}] to [#{endC}, #{endR}]."
		end
	end

	
	def trace begR, begC, endR, endC
		q = [] # to be used as a queue in a breadth-first search

		start_cell = @cell_matrix[begR, begC]
		q.push start_cell # enqueue

		solution = find_maze_path q, endR, endC

		start_cell.parent = nil
		if solution.nil?
			return false
		else
			print_path solution
		end
	end

	# TODO - make this
	# based off of http://www.mazeworks.com/mazegen/mazetut/
	def redesign (rows = @num_rows, cols = @num_cols)
		@num_rows = rows
		@num_cols = cols
		@cell_matrix = Matrix.build(rows, cols) {|r, c| Cell.new(r, c) }
		@cell_matrix.each { |cell| cell.add_neighbors @cell_matrix}


		start_row = rand(0...@num_rows)
		start_col = rand(0...@num_cols)
		break_walls @cell_matrix[start_row, start_col]

		@cell_matrix.each { |cell| cell.visited = false}

		@wall_matrix = set_walls
	end


	private

	def break_walls curr_cell
		curr_cell.visited = true
		opposites = {top: :bottom, bottom: :top, left: :right, right: :left}
		options = [:top, :left, :right, :bottom].delete_if {|sym| curr_cell.neighbors[sym].nil? or curr_cell.neighbors[sym].visited == true}

		until options.empty?
			rand_sym = options[rand(options.size())]
			options.delete rand_sym
			curr_cell.walls[rand_sym] = false
			curr_cell.neighbors[rand_sym].walls[opposites[rand_sym]] = false
			break_walls curr_cell.neighbors[rand_sym]
			options.delete_if {|sym| curr_cell.neighbors[sym].nil? or curr_cell.neighbors[sym].visited == true}
		end
	end


	# sets up walls for a new @wall_matrix
	def set_walls
		wall_arr = Array.new(@num_rows*2 +1){ Array.new(@num_cols*2+1, 1) }
		@cell_matrix.each do |cell|
			row = cell.coordinates[:r]
			col = cell.coordinates[:c]

			#top
			wall_arr[row*2][col*2 + 1] = 0 if cell.walls[:top] == false

			#bottom
			wall_arr[row*2 + 2][col*2 + 1] = 0 if cell.walls[:bottom] == false

			#cell space
			wall_arr[row*2 + 1][col*2 + 1] = 0

			#right
			wall_arr[row*2 + 1][col*2 + 2] = 0 if cell.walls[:right] == false

			#left
			wall_arr[row*2 + 1][col*2] = 0 if cell.walls[:left] == false
		end
		wall_arr
	end

	def print_maze_piece row, col
		if @wall_matrix[row][col].to_s.eql? '0'
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

	def find_maze_path q, endR, endC
		dist = 0   # tracks how many steps currently into the maze we are
		# use a breadth first search to find the shortest path
		until q.empty?
			dist += 1
			current_cell = q.shift # dequeue
			current_cell.travelable_neighbors.each do |neighbor|
				unless neighbor.visited and neighbor.distance < dist
					q.push neighbor  # enqueue
					set_neighbor neighbor, current_cell, dist
					return neighbor if neighbor.coordinates[:c].to_i == endC.to_i and neighbor.coordinates[:r].to_i == endR.to_i
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

		path.each { |cell| print "[#{cell.coordinates[:c]}, #{cell.coordinates[:r]}] -> "}
		print "END"
	end

end


# TESTing code below
m= Maze.new 4, 4
m.load "111111111100010001111010101100010101101110101100000101111011101100000101111111111"

#puts m.wall_matrix.to_s
m.display

puts m.trace 0,0,3,3

m.redesign 10,10

m.display
puts m.trace 0,0,9,9