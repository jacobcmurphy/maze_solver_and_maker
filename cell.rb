# Author: Jacob Murphy

require 'matrix'

##
# Represents a cell within a maze
class Cell
	attr_accessor :neighbors, :walls, :visited, :distance, :parent

	##
	# Creates a new cell at position (r,c) in the maze
	def initialize r, c
		@row = r
		@col = c

		@neighbors = {top: nil, right: nil, bottom: nil, left: nil}
		@walls =     {top: true, right: true, bottom: true, left: true}

		@parent = nil
		@distance = (r*c) + 10 # ensures the distance is greater than the number of cells in the maze
		@visited = false
	end

	##
	# Returns a hash of the coordinates of this cell
	def coordinates
		{c: @col.to_i, r: @row.to_i}
	end

	##
	# Returns an array of all Cells that can be reached from the current cell
	def travelable_neighbors
		available = []
		@walls.each do |key, val|
			available << @neighbors[key] unless val or @neighbors[key].nil?
		end
		available
	end

	##
	# Add information about this cell's walls and neighboring cells
	def add_information cell_matrix, wall_matrix
		add_neighbors cell_matrix
		add_walls wall_matrix
	end

	##
	# Update the neighbors hash based on the cell Matrix given
	def add_neighbors cell_matrix
		@neighbors[:left]   = cell_matrix[ @row, @col - 1 ] unless @col == 0
		@neighbors[:top]    = cell_matrix[ @row - 1, @col ] unless @row == 0
		@neighbors[:right]  = cell_matrix[ @row, @col + 1 ] unless @col == (cell_matrix.to_a)[0].length-1
		@neighbors[:bottom] = cell_matrix[ @row + 1, @col ] unless @row == (cell_matrix.to_a).length-1
	end

	##
	# Update the walls hash based on the array of walls given
	# 0 represents no wall, 1 represents a wall
	def add_walls wall_matrix
		@walls[:top]    = ( wall_matrix[ @row*2    ][ @col*2 +1 ].to_i == 0) ? false : true
		@walls[:bottom] = ( wall_matrix[ @row*2 +2 ][ @col*2 +1 ].to_i == 0) ? false : true
		@walls[:right]  = ( wall_matrix[ @row*2 +1 ][ @col*2 +2 ].to_i == 0) ? false : true
		@walls[:left]   = ( wall_matrix[ @row*2 +1 ][ @col*2    ].to_i == 0) ? false : true
	end

	##
	# Resets the cell to how it was before anything was changed by Maze#find_maze_path or Maze#redesign
	def reset
		@walls.each { |key,val| @walls[key] = true }
		@parent = nil
		@distance = @row * @col +10
		@visited = false
	end
end