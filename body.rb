require "gosu"
require_relative "z_order"

class Body

	attr_reader :x_coordinate, :y_coordinate, :x_vel, :y_vel, :mass, :image, :universe_radius

	def initialize(x_coordinate, y_coordinate, x_vel, y_vel, mass, image, universe_radius)
		@x_coordinate = x_coordinate
		@y_coordinate = y_coordinate
		@x_vel = x_vel
		@y_vel = y_vel
		@universe_radius = universe_radius
		@mass = mass
		puts image
		file = "images/" + image
		@image = Gosu::Image.new(file)

	end

	def draw()
		# 320 is half of the window to create a central 0,0 origin
		x_position = ((x_coordinate / universe_radius) * 320) + 320
		y_position = ((y_coordinate / universe_radius) * 320) + 320
		@image.draw(x_position, y_position, 1)

	end

end
