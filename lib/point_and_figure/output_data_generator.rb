module PointAndFigure
  class OutputDataGenerator
    def initialize(base_point, base_turn, data_set)
      @base_point = base_point
      @base_turn = base_turn
      @data_set = data_set
      @round_unit = PointAndFigure.calc_round_unit base_point
      @output_data = {
        base_point: @base_point,
        base_turn: @base_turn,
        data_set: []
      }
      @prev_value = @data_set[0]
      @current_trend = nil
      @current_line = 1
      @current_max = @data_set[0].floor @round_unit
      @current_min = @data_set[0].ceil @round_unit
    end

    def generate
      @data_set.each.with_index(1) do |value, i|
        next if i == 1
        if up_trend?
          if (floor_or_ceil(value) - @current_max).abs < @base_point
            @prev_value = floor_or_ceil value
            next
          end
          generate_point value
        elsif down_trend?
          if (@current_min - floor_or_ceil(value)).abs < @base_point
            @prev_value = floor_or_ceil value
            next
          end
          generate_point value
        else
          @current_trend = :up if (value.floor(@round_unit) - @current_max).round(@round_unit) >= @base_point
          @current_trend = :down if (@current_min - value.ceil(@round_unit)).round(@round_unit) >= @base_point
          next if @current_trend.nil?
          generate_point value
        end
      end
      @output_data
    end

    private

      def generate_point(value)
        if diff_max_or_min(value) >= @base_point
          generator = PointAndFigure::PointGenerator.new @base_point, floor_or_ceil(value), floor_or_ceil(@prev_value), @current_line, @output_data
          @output_data = generator.generate trend: @current_trend
          update_current_max_or_min value
        elsif trend_changed_point(value)> @base_turn
          @current_line += 1
          reverse_current_trend
          generator = PointAndFigure::PointGenerator.new @base_point, floor_or_ceil(value), current_max_or_min, @current_line, @output_data
          @output_data = generator.generate trend: @current_trend, trend_changed: true
          update_current_max_or_min_reverse value
        end
      end

      def floor_or_ceil(value)
        return value.floor(@round_unit) if up_trend?
        return value.ceil(@round_unit) if down_trend?
      end

      def floor_or_ceil_reverse(value)
        return value.floor(@round_unit) if down_trend?
        return value.ceil(@round_unit) if up_trend?
      end

      def diff_max_or_min(value)
        return (floor_or_ceil(value) - @current_max).round(@round_unit) if up_trend?
        return (@current_min - floor_or_ceil(value)).round(@round_unit) if down_trend?
      end

      def trend_changed_point(value)
        return ((@current_max - floor_or_ceil_reverse(value)) / @base_point).round if up_trend?
        return ((floor_or_ceil_reverse(value) - @current_min) / @base_point).round if down_trend?
      end

      def update_current_max_or_min(value)
        @current_max = @prev_value = floor_or_ceil(value) if up_trend?
        @current_min = @prev_value = floor_or_ceil(value) if down_trend?
      end

      def update_current_max_or_min_reverse(value)
        @current_max = @prev_value = floor_or_ceil_reverse(value) if up_trend?
        @current_min = @prev_value = floor_or_ceil_reverse(value) if down_trend?
      end

      def current_max_or_min
        return @current_max if down_trend?
        return @current_min if up_trend?
      end

      def up_trend?
        @current_trend == :up
      end

      def down_trend?
        @current_trend == :down
      end

      def reverse_current_trend
        @current_trend = up_trend? ? :down : :up
      end
  end
end
