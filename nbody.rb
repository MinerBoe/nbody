require "gosu"
require_relative "z_order"
require "./body"

class NbodySimulation < Gosu::Window

	attr_accessor :bodies

  def initialize(file)
    super(640, 640, false)
    self.caption = "NBody simulation"
    @background_image = Gosu::Image.new("images/space.jpg", tileable: true)
    @bodies = []
    simulation = open(file)
    info = simulation.read
    radius_of_universe = 0
    line_num = 1
    number_of_bodies = 0
    bodies_counted = 0
    File.open(file).each do |line|

    	body_values = []

    	info = line.split(" ")
    	if line_num == 1 && info[0] != nil
    		number_of_bodies = info[0].to_f
    		line_num += 1
    	elsif line_num == 2 && info[0] != nil
			radius_of_universe = info[0].to_f
			line_num += 1
    	elsif bodies_counted < number_of_bodies
    		if info[0] != nil 
				body_values.push(info[0])
				body_values.push(info[1])
				body_values.push(info[2])
				body_values.push(info[3])
				body_values.push(info[4])
				body_values.push(info[5])
				body_values.push(info[6]) # body_radius
				if info[7] != nil
					body_values.push(info[7]) # z_velocity
				else
					body_values.push(0) # if no z_velocity given, default to 0
				end


				@bodies.push(Body.new(body_values[0].to_f, body_values[1].to_f, body_values[2].to_f, body_values[3].to_f, body_values[4].to_f, body_values[5].to_s, radius_of_universe, self.width, body_values[6].to_f, body_values[7.to_f]))
    			bodies_counted += 1

    		end
    	end
  	end
  end

  def update
  	@bodies.each do |body|
      if body.did_collide?(@bodies) == true
      	# create a new body with the pre-collision body's velocity, location, and radius
      	# but that is half the mass of the original
      	@bodies.push(Body.new(#initial values))
      end
    end
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @bodies.each do |body|
      body.draw(@bodies)
    end
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end

end

file = "simulations/"

if ARGV.length == 0
	# default simulation
	file = file + "planets.txt"

else
	# accepts command line text in form of array takes the first one
	# sets it equal to the input, combines with the initial file location
	input = ARGV
	input = input[0]
	file = file + input
end

window = NbodySimulation.new(file)
window.show