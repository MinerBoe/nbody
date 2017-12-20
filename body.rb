require "gosu"
require_relative "z_order"
require 'mathn'

G = 6.67408e-11
TIME = 25000

class Body

	attr_accessor :x_position, :y_position, :x_coordinate, :y_coordinate, :x_vel, :y_vel, :mass, :image, :universe_radius, :half_window, :window_size, :z_vel, :body_radius

	def initialize(x_coordinate, y_coordinate, x_vel, y_vel, mass, image, universe_radius, window_size, body_radius, z_vel)
		@z_vel = z_vel
		@body_radius = body_radius
		@x_coordinate = x_coordinate
		@y_coordinate = y_coordinate
		@z_coordinate = 0
		@window_size = window_size
		# 320 is half of the window to create a central 0,0 origin
		@half_window = @window_size / 2.0
		@x_vel = x_vel
		@y_vel = y_vel
		@universe_radius = universe_radius
		@mass = mass
		file = "images/" + image
		@image = Gosu::Image.new(file)
		@x_position = ((x_coordinate / universe_radius) * half_window) + half_window - (@image.width/2)
		@y_position = ((y_coordinate / universe_radius) * half_window) + half_window - (@image.height/2)
		@z_position = ((z_coordinate / universe_radius) * half_window) + half_window - (@image.height/2)
	end

	def draw(bodies)
		d = []
		d = calculate_force(bodies)
		d_x = (d[0].to_f / universe_radius) * half_window
		d_y = (d[1].to_f / universe_radius) * half_window
		d_z = (d[2].to_f / universe_radius) * half_window
		@x_position = @x_position + d_x
		@y_position = @y_position - d_y

		if @z_position + d_z > 0 
			# greater than one scale
			@image.width = @image.width * 5
			@image.height = @image.height * 5
			# change the ZOrder to in front of the other planets
		elsif @z_position + d_z < 0 
			# less than one scale
			@image.width = @image.width * 0.2
			@image.height = @image.height * 0.2
			# change the ZOrder to behind the other planets
		end

		# check if the body left the universe radius before drawing
		@image.draw(@x_position, @y_position, ZOrder::Body)
	end

	def calculate_force(bodies)

		total_force_x = 0
		total_force_y = 0
		total_force_z = 0
		d_x = 0
		d_y = 0
		d_z = 0

		bodies.each do |body|

			if body != self 

				dx = body.x_coordinate - self.x_coordinate
				dy = body.y_coordinate - self.y_coordinate
				dz = body.z_coordinate - self.z_coordinate
				distance = calculate_distance(dx, dy)
				# change distance to include z distance
				force = (G * self.mass * body.mass) / (distance * distance)
				force_x = force * (dx/distance)
				force_y = force * (dy/distance)
				force_z = force * (dz/distance)
				total_force_x += force_x
				total_force_y += force_y
				total_force_z += force_z

			end
		end
		
		a_x = total_force_x / mass
		v_x = (a_x * TIME) + x_vel
		d_x = (v_x * TIME) + x_position

		@x_vel = v_x
		@x_coordinate += d_x

		a_y = (total_force_y / mass)
		v_y = (a_y * TIME) + y_vel
		d_y = (v_y * TIME) + y_position

		@y_vel = v_y
		@y_coordinate += d_y

		a_z = (total_force_z / mass)
		v_z = (a_z * TIME) + z_vel
		d_z = (v_z * TIME) + z_position

		@z_vel = v_z
		@z_coordinate += d_z

		return d_x, d_y, d_z
	end

	def calculate_distance(dx, dy)
		dx_squared = dx * dx
		dy_squared = dy * dy
		distance = Math.sqrt(dx_squared + dy_squared)

		return distance
	end

	def did_collide?(bodies)
		bodies.each do |body|
			if body != self
				# compare this body's coordinates and radius with those of the other bodies
		
				dx = body.x_coordinate - self.x_coordinate
				dy = body.y_coordinate - self.y_coordinate
				distance = calculate_distance(dx, dy)
				if distance <= (self.body_radius + body.body_radius)
					return true # collision occurred
				end
			end
		end
		
		return false # no collision occurred

	end

end