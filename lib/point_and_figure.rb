require 'point_and_figure/version'
require 'point_and_figure/output_data_generator'
require 'point_and_figure/point_generator'

module PointAndFigure
  class << self
    def generate(input_data)
      # TODO: error handle
      base_point = input_data[:base_point]
      base_turn = input_data[:base_turn]
      data_set = input_data[:data_set]

      generator = PointAndFigure::OutputDataGenerator.new base_point, base_turn, data_set
      generator.generate
    end

    def calc_round_unit(base_point)
      s = base_point.to_s
      if s.is_a?(Integer)
        1 - s.size
      else
        s.split('.')[1].size
      end
    end
  end
end
