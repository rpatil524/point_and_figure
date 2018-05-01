require "test_helper"

class PointAndFigureTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PointAndFigure::VERSION
  end

  def test_it_returns_valid_json
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [100, 100.1]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal input_data[:base_point], output_data[:base_point]
    assert_equal input_data[:base_turn], output_data[:base_turn]
    assert_equal [[1, 100, 100.1]], output_data[:data_set]
  end

  def test_it_returns_multi_flame_when_trend_is_up
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [100, 100.29]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 100, 100.1], [1, 100.1, 100.2]], output_data[:data_set]
  end

  def test_it_returns_multi_flame_when_trend_is_down
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [100.11, 99.99]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 100.2, 100.1], [1, 100.1, 100]], output_data[:data_set]
  end

  def test_it_turns_line_when_trend_changes_from_up_to_down
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [100.3, 100.49, 99.99]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 100.3, 100.4], [2, 100.3, 100.2], [2, 100.2, 100.1], [2, 100.1, 100]], output_data[:data_set]
  end

  def test_it_turns_line_when_trend_changes_from_down_to_up
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [100.09, 99.99, 100.49]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 100.1, 100], [2, 100.1, 100.2], [2, 100.2, 100.3], [2, 100.3, 100.4]], output_data[:data_set]
  end

  def test_it_doesnt_turn_line_when_trend_not_changed_from_up_to_down
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [100.31, 100.49, 100.09]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 100.3, 100.4]], output_data[:data_set]
  end

  def test_it_doesnt_turn_line_when_trend_not_changed_from_down_to_up
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [100.09, 99.99, 100.39]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 100.1, 100]], output_data[:data_set]
  end

  def test_it_turn_down_line_when_trend_changes_after_many_days
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [100.39, 100.4, 100.01, 100]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 100.3, 100.4], [2, 100.3, 100.2], [2, 100.2, 100.1], [2, 100.1, 100]], output_data[:data_set]
  end

  def test_it_turn_up_line_when_trend_changes_after_many_days
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [100.09, 100, 100.1, 100.49]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 100.1, 100], [2, 100.1, 100.2], [2, 100.2, 100.3], [2, 100.3, 100.4]], output_data[:data_set]
  end

  def test_it_has_continuous_line_when_trend_changes_up
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [112.66, 112.3, 112.5, 112.75, 113.08]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 112.7, 112.6], [1, 112.6, 112.5], [1, 112.5, 112.4], [1, 112.4, 112.3], [2, 112.4, 112.5], [2, 112.5, 112.6], [2, 112.6, 112.7], [2, 112.7, 112.8], [2, 112.8, 112.9], [2, 112.9, 113]], output_data[:data_set]
  end

  def test_it_has_continuous_line_when_trend_changes_down
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [110.45, 111.28, 110.78, 110.92, 110.31]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 110.4, 110.5], [1, 110.5, 110.6], [1, 110.6, 110.7], [1, 110.7, 110.8], [1, 110.8, 110.9], [1, 110.9, 111], [1, 111, 111.1], [1, 111.1, 111.2], [2, 111.1, 111], [2, 111, 110.9], [2, 110.9, 110.8], [2, 110.8, 110.7], [2, 110.7, 110.6], [2, 110.6, 110.5], [2, 110.5, 110.4]], output_data[:data_set]
  end

  def test_actual_data
    data = [0.11266e3, 0.1123e3, 0.1125e3, 0.11275e3, 0.11308e3, 0.11309e3, 0.11266e3, 0.11144e3, 0.11125e3, 0.11104e3, 0.11054e3, 0.11045e3, 0.11128e3, 0.11111e3, 0.11078e3, 0.11092e3, 0.11031e3, 0.10922e3, 0.10941e3, 0.10872e3, 0.10895e3, 0.10878e3, 0.10919e3, 0.10941e3, 0.11011e3, 0.10911e3, 0.10956e3, 0.10933e3, 0.10875e3, 0.1088e3, 0.10866e3, 0.10783e3, 0.10702e3, 0.10612e3, 0.10631e3, 0.1066e3, 0.10733e3, 0.10778e3, 0.10675e3, 0.10689e3, 0.10694e3, 0.10733e3, 0.10667e3, 0.10624e3, 0.10575e3, 0.1062e3, 0.10612e3, 0.10608e3, 0.1062e3, 0.1068e3, 0.10642e3, 0.10658e3, 0.10633e3, 0.10634e3, 0.10602e3, 0.10609e3, 0.10653e3, 0.10606e3, 0.10528e3, 0.10474e3, 0.10541e3, 0.10534e3, 0.10686e3, 0.10643e3, 0.10628e3, 0.10589e3, 0.10661e3, 0.10678e3, 0.10738e3, 0.10693e3, 0.10677e3, 0.1072e3, 0.1068e3, 0.10733e3, 0.10734e3, 0.10711e3, 0.107e3, 0.10723e3, 0.10738e3, 0.10767e3, 0.10871e3, 0.10882e3, 0.10942e3, 0.10931e3, 0.10905e3]
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: data
    }
    output_data = PointAndFigure.generate input_data
    assert_equal 262, output_data[:data_set].size
    assert_equal [1, 112.7, 112.6], output_data[:data_set].min_by { |v| v[0]}
    assert_equal [22, 106.9, 107.0], output_data[:data_set].max_by { |v| v[0]}
  end

  def test_it_returns_valid_data_when_modified_base_point
    input_data = {
      base_point: 0.2,
      base_turn: 3,
      data_set: [110.49, 111.01, 110.19]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 110.4, 110.6], [1, 110.6, 110.8], [1, 110.8, 111], [2, 110.8, 110.6], [2, 110.6, 110.4], [2, 110.4, 110.2]], output_data[:data_set]
  end
end
