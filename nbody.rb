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
    line_num = 0
    number_of_bodies = 0
    bodies_counted = 0
    File.open(file).each do |line|

    	body_values = []
    	line_num += 1
    	info = line.split(" ")
    	if line_num == 1 
    		number_of_bodies = info[0].to_f
    	elsif line_num == 2
			radius_of_universe = info[0].to_f
    	elsif line_num != 1 && line_num != 2 && bodies_counted < number_of_bodies
    		if info[0] != nil 
				body_values.push(info[0])
				body_values.push(info[1])
				body_values.push(info[2])
				body_values.push(info[3])
				body_values.push(info[4])
				body_values.push(info[5])

				@bodies.push(Body.new(body_values[0].to_f, body_values[1].to_f, body_values[2].to_f, body_values[3].to_f, body_values[4].to_f, body_values[5].to_s, radius_of_universe))
    			bodies_counted += 1

    		end
    	end
  	end
  end

  def update

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
