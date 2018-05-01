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
      @data_set.each.with_index do |value, i|
        # 初期値か
        next if i.zero?

        # 現在の枠が☓か○か
        if up_trend?
          # 高値を1枠以上更新したか
          if (value.floor(@round_unit) - @current_max).round(@round_unit) >= @base_point
            generator = PointAndFigure::PointGenerator.new @base_point, value.floor(@round_unit), @current_max, @current_line, @output_data
            @output_data = generator.generate trend: @current_trend
            @current_max = value.floor @round_unit
            next
          else
            # 高値の枠より基準枠以上価格が下がったか
            if ((@current_max - value.ceil(@round_unit)) / @base_point).round > @base_turn
              @current_trend = :down
              @current_line += 1
              @current_min = value.ceil @round_unit
              generator = PointAndFigure::PointGenerator.new @base_point, @current_min, @current_max, @current_line, @output_data
              @output_data = generator.generate trend: @current_trend, trend_changed: true
              next
            else
              next
            end
          end
        elsif down_trend?
          # 安値を1枠以上更新したか
          if (@current_min - value.ceil(@round_unit)).round(@round_unit) >= @base_point
            generator = PointAndFigure::PointGenerator.new @base_point, value.ceil(@round_unit), @current_min, @current_line, @output_data
            @output_data = generator.generate trend: @current_trend
            @current_min = value.ceil @round_unit
            next
          else
            # 安値の枠より基準枠以上価格が上がったか
            if ((value.floor(@round_unit) - @current_min) / @base_point).round > @base_turn
              @current_trend = :up
              @current_line += 1
              @current_max = value.floor @round_unit
              generator = PointAndFigure::PointGenerator.new @base_point, @current_max, @current_min, @current_line, @output_data
              @output_data = generator.generate trend: @current_trend, trend_changed: true
              next
            else
              next
            end
          end
        else
          # 高値or安値を1枠以上更新したか
          if (value.floor(@round_unit) - @current_max).round(@round_unit) >= @base_point
            @current_trend = :up
            generator = PointAndFigure::PointGenerator.new @base_point, value.floor(@round_unit), @current_max, @current_line, @output_data
            @output_data = generator.generate trend: @current_trend
            @current_max = value.floor @round_unit
          elsif (@current_min - value.ceil(@round_unit)).round(@round_unit) >= @base_point
            @current_trend = :down
            generator = PointAndFigure::PointGenerator.new @base_point, value.ceil(@round_unit), @current_min, @current_line, @output_data
            @output_data = generator.generate trend: @current_trend
            @current_min = value.ceil @round_unit
          end
        end
      end
      @output_data
    end

    private

      def up_trend?
        @current_trend == :up
      end

      def down_trend?
        @current_trend == :down
      end
  end
end
