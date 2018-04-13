module PointAndFigure
  class PointGenerator
    def initialize(base_point, current_value, prev_value, current_line, output_data)
      @base_point = base_point
      @current_value = current_value
      @prev_value = prev_value
      @current_line = current_line
      @output_data = output_data
      @round_unit = PointAndFigure.calc_round_unit base_point
      @flame = ((current_value - prev_value) / base_point).round(@round_unit).abs
    end

    def generate(trend:, trend_changed: false)
      operator = trend == :up ? :+ : :-
      @output_data.tap do |output_data|
        (0...@flame).each do |i|
          next if i == 0 && trend_changed
          output_data[:data_set] << [@current_line,
                                     (@prev_value.send(operator, @base_point * i)).round(@round_unit),
                                     (@prev_value.send(operator, @base_point * (i + 1))).round(@round_unit)]
        end
      end
    end
  end
end
