# Author: Jacob Murphy

##
# Used to handle the generation and redesigning of new mazes
class MazeBuilder
	attr_accessor :wall_matrix, :cell_matrix, :num_rows, :num_cols

	##
	# Creates a new MazeBuilder
	# The Maze class depends on these attributes
	def initialize r, c
		@num_rows = r
		@num_cols = c

		@wall_matrix = []
		@cell_matrix = Matrix.build(@num_rows, @num_cols) {|row, col| Cell.new(row, col) }
	end

	##
	# Convert a string of 0's and 1's into a 2D array
	# The array represents the walls and empty spaces of the maze
	def load_str str
		@wall_matrix = str.to_s.split('').each_slice(@num_cols*2 +1).to_a

		# load the cell matrix
		@cell_matrix.each do |cell|
			cell.add_information @cell_matrix, @wall_matrix
		end
	end

	##
	# Create a new maze with dimensions of rows x cols
	# Based off of the depth-first algorithm at http://www.mazeworks.com/mazegen/mazetut/
	def redesign rows, cols
		@num_rows = rows
		@num_cols = cols
		@cell_matrix = Matrix.build(rows, cols) {|r, c| Cell.new(r, c) }
		@cell_matrix.each { |cell| cell.add_neighbors @cell_matrix}


		break_walls @cell_matrix[rand(0...@num_rows), rand(0...@num_cols)]
		@cell_matrix.each { |cell| cell.visited = false}
		@wall_matrix = set_walls
	end


	# *************** Private Methods below *************** #
	private

	##
	# Depth-first approach of removing walls from cells to generate a new maze
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


	##
	# Sets up walls for a new @wall_matrix
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
end