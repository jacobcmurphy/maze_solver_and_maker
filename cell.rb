# Author: Jacob Murphy

require 'matrix'

class Cell
	attr_accessor :neighbors, :walls, :visited, :distance, :parent
	def initialize x, y
		@row = x
		@col = y

		@neighbors = {top: nil, right: nil, bottom: nil, left: nil}
		@walls =     {top: true, right: true, bottom: true, left: true}

		@parent = nil
		@distance = (x*y) + 10 # ensures the distance is greater than the number of cells in the maze
		@visited = false
	end

	def coordinates
		{x: @row.to_i, y: @col.to_i}
	end

	def travelable_neighbors
		available = []
		@walls.each do |key, val|
			available << @neighbors[key] unless val or @neighbors[key].nil?
		end
		available
	end

	def add_information cell_matrix, wall_matrix
			@neighbors[:left]   = cell_matrix[ @row, @col - 1 ] unless @col == 0
			@neighbors[:top]    = cell_matrix[ @row - 1, @col ] unless @row == 0
			@neighbors[:right]  = cell_matrix[ @row, @col + 1 ] unless @col == (cell_matrix.to_a)[0].length-1
			@neighbors[:bottom] = cell_matrix[ @row + 1, @col ] unless @row == (cell_matrix.to_a).length-1

			# 0 represents no wall, 1 represents a wall
			@walls[:top]    = ( wall_matrix[ @row*2    ][ @col*2 +1 ].to_i == 0) ? false : true
			@walls[:bottom] = ( wall_matrix[ @row*2 +2 ][ @col*2 +1 ].to_i == 0) ? false : true
			@walls[:right]  = ( wall_matrix[ @row*2 +1 ][ @col*2 +2 ].to_i == 0) ? false : true
			@walls[:left]   = ( wall_matrix[ @row*2 +1 ][ @col*2    ].to_i == 0) ? false : true

	end

	def reset
		@walls.each { |key,val| @walls[key] = true }
		@distance = @row * @col +10
		@visited = false
	end

end