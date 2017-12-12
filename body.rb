require "gosu"
require_relative "z_order"
require 'mathn'

G = 6.67408e-11


class Body

	attr_accessor :x_position, :y_position, :x_coordinate, :y_coordinate, :x_vel, :y_vel, :mass, :image, :universe_radius, :half_window, :window_size

	def initialize(x_coordinate, y_coordinate, x_vel, y_vel, mass, image, universe_radius, window_size)
		@x_coordinate = x_coordinate
		@y_coordinate = y_coordinate
		@window_size = window_size
		# 320 is half of the window to create a central 0,0 origin
		@half_window = @window_size / 2.0
		@x_position = ((x_coordinate / universe_radius) * half_window) + half_window
		@y_position = ((y_coordinate / universe_radius) * half_window) + half_window
		@x_vel = x_vel
		@y_vel = y_vel
		@universe_radius = universe_radius
		@mass = mass
		file = "images/" + image
		@image = Gosu::Image.new(file)

	end

	def draw(bodies)
		d = []
		d = calculate_force(bodies)
		d_x = (d[0].to_f / universe_radius) * half_window
		d_y = (d[1].to_f / universe_radius) * half_window
		@x_position = @x_position + d_x
		@y_position = @y_position + d_y
		@image.draw(@x_position, @y_position, ZOrder::Body)
	end

	def calculate_force(bodies)
		total_force_x = 0
		total_force_y = 0
		d_x = 0
		d_y = 0

		bodies.each do |body|

			if body != self 

				dx = body.x_coordinate - self.x_coordinate
				dy = body.y_coordinate - self.y_coordinate
				distance = calculate_distance(dx, dy)
				force = (G * self.mass * body.mass) / (distance * distance)
				force_x = force * (dx/distance)
				force_y = force * (dy/distance)
				total_force_x += force_x
				total_force_y += force_y

			end
		end

		t = 25000
		
		a_x = total_force_x / mass
		v_x = (a_x * t) + x_vel
		d_x = x_vel + (v_x * t)

		@x_vel = v_x
		@x_coordinate += d_x

		a_y = total_force_y / mass
		v_y = (a_y * t) + y_vel
		d_y = y_vel + (v_y * t)
		@y_vel = v_y
		@y_coordinate += d_y

		return d_x, d_y
	end

	def calculate_distance(dx, dy)
		dx = dx * dx
		dy = dy * dy
		distance = Math.sqrt(dx + dy)

		return distance
	end

end