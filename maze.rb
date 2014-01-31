# Author: Jacob Murphy

require_relative 'cell'

class Maze
	attr_accessor :wall_matrix

	def initialize x, y
		@num_rows = (x*2)+1
		@num_cols = (y*2)+1

		@wall_matrix = []
	end

	# TODO: add validity check
	def load str
		@wall_matrix = str.to_s.split('').each_slice(@num_cols).to_a
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
		trace begX, begY, endX, endY
	end

	def trace begX, begY, endX, endY
	end

	def redesign
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
end


# TESTing code below
m= Maze.new 4, 4
m.load "111111111100010001111010101100010101101110101100000101111011101100000101111111111"

#puts m.wall_matrix.to_s
m.display