# Author: Jacob Murphy

class Cell
	attr_accessor :neighbors, :walls, :visited, :row, :col
	def initialize x, y
		@row = x
		@col = y

		@neighbors = {top: nil, right: nil, bottom: nil, left: nil}
		@walls = {top: true, right: true, bottom: true, left: true}

		@visited = false
	end

	def coordinates
		[@row, @col]
	end

	def travelable_neighbors
		available = []
		@walls.each do |key, val|
			available << @neighbors[key] unless @walls[val]
		end
		available
	end

end