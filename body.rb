require "gosu"
require_relative "z_order"

class Body

	attr_reader :x_coordinate, :y_coordinate, :x_vel, :y_vel, :mass, :image

	def initialize(x_coordinate, y_coordinate, x_vel, y_vel, mass, image)
		@x_coordinate = x_coordinate
		@y_coordinate = y_coordinate
		@x_vel = x_vel
		@y_vel = y_vel
		@mass = mass
		@image = image
		puts "this is my x_coordinate #{x_coordinate}"
		#puts y_coordinate
		
		# File.open("simulations/planets.txt").each do |line|
  #   		info = line.split("/\n/")
  #   		puts info
  #   		if line == 0
  #   			@number_of_bodies = info[0]
  #   		end

  #   		if line == 1

  #   		end

  #   		if line != 0 && line != 1
  #   			@x_coordinates.push(info[0].strip)
  #   			@y_coordinates.push(info[1])
  #   			@x_vel.push(info[2])
  #   			@y_vel.push(info[3])
  #   			@images.push(info[4])
  #   		end

  #   	end
 
	end

end

