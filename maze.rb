# Author: Jacob Murphy

require 'matrix'
require_relative 'cell'
require_relative 'maze_builder'

##
# Maze class - used for creating, solving, and printing mazes
# uses MazeBuilder to create the layout of the maze
class Maze
	attr_accessor :wall_matrix

	##
	# Creates a new maze
	# r represents the number of rows in the maze
	# c represents the number of columns in the maze
	def initialize r, c
		@maze_builder = MazeBuilder.new r, c

		@num_rows = @maze_builder.num_rows
		@num_cols = @maze_builder.num_cols

		@wall_matrix = @maze_builder.wall_matrix
		@cell_matrix = @maze_builder.cell_matrix
	end

	##
	# Converts a string of 0's and 1's into a maze
	# 0 represents an open space
	# 1 represents a wall in the maze
	def load str# TODO: add validity check
		@maze_builder.load_str str
		@wall_matrix = @maze_builder.wall_matrix
	end

	##
	# Outputs an ASCII representation of the maze
	def display
		for i in 0...@wall_matrix.size
			for j in 0...@wall_matrix[0].size
				print_maze_piece i, j
			end
			print "\n"
		end
	end

	##
	# Determines if the current maze can be solved
	# Uses Maze#trace to check if a solution exists
	def solve begR, begC, endR, endC
		result = trace begR, begC, endR, endC, false
		if result
			puts "\nThere is a possible solution getting from to [#{begC}, #{begR}] to [#{endC}, #{endR}]."
		else
			puts "\nThere is no possible solution to get from [#{begC}, #{begR}] to [#{endC}, #{endR}]."
		end
		result
	end

	##
	# Finds the shortest solution to the current maze if it exists
	# Calls find_maze_path, which uses a breadth-first search to find the shortest pass
	#
	# Returns false if there is no solution to the maze
	# Prints the solution with print_path and returns true if there is a solution
	def trace (begR, begC, endR, endC, print_out = true)
		q = [] # to be used as a queue in a breadth-first search

		start_cell = @cell_matrix[begR, begC]
		q.push start_cell # enqueue

		solution = find_maze_path q, endR, endC

		start_cell.parent = nil
		if solution.nil?
			return false
		else
			print_path solution if print_out
			return true
		end
	end

	##
	# Creates a new maze
	# If no parameters are given, the new maze will be the same size as the current maze
	def redesign (rows = @num_rows, cols = @num_cols)
		@maze_builder.redesign rows, cols
		@wall_matrix = @maze_builder.wall_matrix
		@cell_matrix = @maze_builder.cell_matrix
	end



	# *************** Private Methods below *************** #
	private

	# Prints either a wall or an empty space in the ASCII layout of the maze
	def print_maze_piece row, col
		if @wall_matrix[row][col].to_s.eql? '0' # 0 represents an empty space in the maze
			print ' '
		else
			if row%2 == 0
				if col%2 == 0
					print '+'  # even row and even column
				else
					print '-'  # even row and odd column
				end
			else # odd numbered rows are either empty or a pipe
				print '|'
			end
		end
	end

	##
	# Finds the solution to the maze
	# Uses a breadth-first search to find the shortest path to the endpoint
	def find_maze_path q, endR, endC
		dist = 0   # tracks how many steps currently into the maze we are
		until q.empty?
			dist += 1
			current_cell = q.shift # dequeue
			current_cell.travelable_neighbors.each do |neighbor|
				# only update if the cell can be reached by a shorter path than before
				unless neighbor.visited and neighbor.distance < dist
					q.push neighbor  # enqueue
					set_neighbor neighbor, current_cell, dist
					return neighbor if neighbor.coordinates[:c].to_i == endC.to_i and neighbor.coordinates[:r].to_i == endR.to_i
				end
			end
		end
		nil # return nil if no valid path is found
	end

	##
	# set the information used by find_maze_path
	def set_neighbor neighbor, parent, dist
		neighbor.parent = parent
		neighbor.visited = true
		neighbor.distance = dist
	end

	##
	# Outputs the path 
	# [1,2] represent row 1, column 2
	def print_path end_cell
		path = []
		until end_cell.nil?
			path.unshift end_cell
			end_cell = end_cell.parent
		end

		path.each { |cell| print "[#{cell.coordinates[:c]}, #{cell.coordinates[:r]}] ->   "}
		print "END"
	end

end