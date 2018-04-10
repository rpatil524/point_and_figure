require "point_and_figure/version"

module PointAndFigure
  class << self
    def generate(input_data)
      base_point = input_data[:base_point]
      base_turn = input_data[:base_turn]
      data_set = input_data[:data_set]
      output_data = {
        base_point: base_point,
        base_turn: base_turn,
        data_set: []
      }
      prev_value = data_set[0]
      current_trend = nil
      current_line = nil
      round_unit = (1 / base_point).to_i.to_s.size - 1
      current_max = data_set[0].floor round_unit
      current_min = data_set[0].ceil round_unit
      data_set.each.with_index(1) do |value, i|
        next if i == 1
        current_line ||= 1
        value_floor = value.floor round_unit
        value_ceil = value.ceil round_unit
        prev_value_floor = prev_value.floor round_unit
        prev_value_ceil = prev_value.ceil round_unit
        if current_trend.nil?
          if (value_floor - prev_value_floor).round(round_unit) >= base_point
            current_trend = :up
            output_data = up_data(base_point, value_floor, prev_value_floor, current_line, output_data)
            prev_value = value_floor
            current_max = value_floor
            next
          elsif (prev_value_ceil - value_ceil).round(round_unit) >= base_point
            current_trend = :down 
            output_data = down_data(base_point, value_ceil, prev_value_ceil, current_line, output_data)
            prev_value = value_ceil
            current_min = value_ceil
            next
          end
        end
        if current_trend == :up
          diff_max = value_floor - current_max
          if diff_max.abs < base_point
            prev_value = value_floor
            next
          end
          if diff_max.round(round_unit) >= base_point
            output_data = up_data(base_point, value_floor, prev_value_floor, current_line, output_data)
            current_max = value_floor
            prev_value = value_floor
          elsif ((current_max - value_ceil) / base_point).round > base_turn
            current_line += 1
            output_data = down_data(base_point, value_ceil, current_max, current_line, output_data, trend_changed: true)
            current_trend = :down
            current_min = value_ceil
            prev_value = value_ceil
          end
        elsif current_trend == :down
          diff_min = current_min - value_ceil
          if diff_min.abs < base_point
            prev_value = value_ceil
            next
          end
          if diff_min.round(round_unit) >= base_point
            output_data = down_data(base_point, value_ceil, prev_value_ceil, current_line, output_data)
            current_min = value_ceil
            prev_value = value_ceil
          elsif ((value_floor - current_min) / base_point).round > base_turn
            current_line += 1
            output_data = up_data(base_point, value_floor, current_min, current_line, output_data, trend_changed: true)
            current_trend = :up
            current_max = value_floor
            prev_value = value_floor
          end
        end
      end
      output_data
    end

    def up_data(base_point, value, prev_value, current_line, output_data, trend_changed: false)
      round_unit = (1 / base_point).to_i.to_s.size - 1
      flame = ((value - prev_value) / base_point).round(round_unit)
      (0...flame).each do |i|
        next if i == 0 && trend_changed
        output_data[:data_set] << [current_line, (prev_value + base_point * i).round(round_unit), (prev_value + base_point * (i + 1)).round(round_unit)]
      end
      output_data
    end

    def down_data(base_point, value, prev_value, current_line, output_data, trend_changed: false)
      round_unit = (1 / base_point).to_i.to_s.size - 1
      flame = ((value - prev_value).round(round_unit) / base_point).abs
      (0...flame).each do |i|
        next if i == 0 && trend_changed
        output_data[:data_set] << [current_line, (prev_value - base_point * i).round(round_unit), (prev_value - base_point * (i + 1)).round(round_unit)]
      end
      output_data
    end
  end
end
