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
      data_set: [100, 100.2]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 100, 100.1], [1, 100.1, 100.2]], output_data[:data_set]
  end

  def test_it_returns_multi_flame_when_trend_is_down
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [100.2, 100]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 100.2, 100.1], [1, 100.1, 100]], output_data[:data_set]
  end

  def test_it_turns_line_when_trend_changes_from_up_to_down
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [100.3, 100.4, 100]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 100.3, 100.4], [2, 100.3, 100.2], [2, 100.2, 100.1], [2, 100.1, 100]], output_data[:data_set]
  end

  def test_it_turns_line_when_trend_changes_from_down_to_up
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [100.1, 100, 100.4]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 100.1, 100], [2, 100.1, 100.2], [2, 100.2, 100.3], [2, 100.3, 100.4]], output_data[:data_set]
  end

  def test_it_doesnt_turn_line_when_trend_not_changed_from_up_to_down
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [100.3, 100.4, 100.1]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 100.3, 100.4]], output_data[:data_set]
  end

  def test_it_doesnt_turn_line_when_trend_not_changed_from_down_to_up
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [100.1, 100, 100.3]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 100.1, 100]], output_data[:data_set]
  end

  def test_it_turn_down_line_when_trend_changes_after_many_days
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [100.3, 100.4, 100.1, 100]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 100.3, 100.4], [2, 100.3, 100.2], [2, 100.2, 100.1], [2, 100.1, 100]], output_data[:data_set]
  end

  def test_it_turn_up_line_when_trend_changes_after_many_days
    input_data = {
      base_point: 0.1,
      base_turn: 3,
      data_set: [100.1, 100, 100.1, 100.4]
    }
    output_data = PointAndFigure.generate input_data
    assert_equal [[1, 100.1, 100], [2, 100.1, 100.2], [2, 100.2, 100.3], [2, 100.3, 100.4]], output_data[:data_set]
  end
end
