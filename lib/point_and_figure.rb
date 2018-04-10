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
      current_max = data_set[0]
      current_min = data_set[0]
      data_set.each.with_index(1) do |value, i|
        next if i == 1
        current_line ||= 1
        if current_trend.nil?
          diff = (value - prev_value).round(2) # FIXME
          if diff >= base_point
            current_trend = :up
            output_data = up_data(base_point, value, prev_value, current_line, output_data)
            prev_value = value
            current_max = value
            next
          end
          if diff.abs >= base_point && diff < 0
            current_trend = :down 
            output_data = down_data(base_point, value, prev_value, current_line, output_data)
            prev_value = value
            current_min = value
            next
          end
        end
        if current_trend == :up
          diff_max = value - current_max
          if diff_max.abs < base_point
            prev_value = value
            next
          end
          if diff_max >= base_point
            output_data = up_data(base_point, value, prev_value, current_line, output_data)
            current_max = value
          elsif (diff_max.abs / base_point).round > base_turn
            current_line += 1
            output_data = down_data(base_point, value, current_max, current_line, output_data, trend_changed: true)
            current_trend = :down
            current_min = value
          end
        elsif current_trend == :down
          diff_min = current_min - value
          if diff_min.abs < base_point
            prev_value = value
            next
          end
          if diff_min >= base_point
            output_data = down_data(base_point, value, prev_value, current_line, output_data)
            current_min = value
          elsif (diff_min.abs / base_point).round > base_turn
            current_line += 1
            output_data = up_data(base_point, value, current_min, current_line, output_data, trend_changed: true)
            current_trend = :up
            current_max = value
          end
        end
        prev_value = value
      end
      output_data
    end

    def up_data(base_point, value, prev_value, current_line, output_data, trend_changed: false)
      flame = ((value - prev_value) / base_point).round(1) # FIXME
      (0...flame).each do |i|
        next if i == 0 && trend_changed
        output_data[:data_set] << [current_line, (prev_value + base_point * i).round(1), (prev_value + base_point * (i + 1)).round(1)] # FIXME
      end
      output_data
    end

    def down_data(base_point, value, prev_value, current_line, output_data, trend_changed: false)
      flame = ((value - prev_value).round(1) / base_point).abs # FIXME
      (0...flame).each do |i|
        next if i == 0 && trend_changed
        output_data[:data_set] << [current_line, (prev_value - base_point * i).round(1), (prev_value - base_point * (i + 1)).round(1)] # FIXME
      end
      output_data
    end
  end
end
