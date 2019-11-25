require_relative "test_helper"

class ThunderSVMTest < Minitest::Test
  def test_classifier
    x = [[1, 2], [3, 4], [5, 6], [7, 8]]
    y = [1, 1, 2, 2]

    model = ThunderSVM::Classifier.new
    model.fit(x, y)
    predictions = model.predict(x)
    expected = [1, 1, 2, 2]
    assert_equal expected, predictions

    path = Tempfile.new.path
    model.save_model(path)

    model = ThunderSVM.load_model(path)
    predictions = model.predict(x)
    assert_equal expected, predictions

    assert_equal 4, model.support_vectors.size
    assert_equal 2, model.support_vectors.first.size

    assert_equal 1, model.dual_coef.size
    assert_elements_in_delta [0.98168445, 1, -1, -0.98168445], model.dual_coef.first
  end

  def test_classifier_file
    x = "test/support/classification.txt"
    model = ThunderSVM::Classifier.new
    model.fit(x)
    predictions = model.predict(x)
    expected = [1, 1, 2, 2]
    assert_equal expected, predictions
  end

  def test_regressor
    x = [[1, 2], [3, 4], [5, 6], [7, 8]]
    y = [1, 2, 3, 4]

    model = ThunderSVM::Regressor.new
    model.fit(x, y)
    predictions = model.predict(x)
    expected = [1.4928788, 2.1, 2.9, 3.507121]
    assert_elements_in_delta expected, predictions

    path = Tempfile.new.path
    model.save_model(path)

    model = ThunderSVM.load_model(path)
    predictions = model.predict(x)
    assert_elements_in_delta expected, predictions
  end

  def test_regressor_file
    x = "test/support/regression.txt"
    model = ThunderSVM::Regressor.new
    model.fit(x)
    predictions = model.predict(x)
    expected = [1.4928788, 2.1, 2.9, 3.507121]
    assert_elements_in_delta expected, predictions
  end

  def test_cv
    x = [[1, 2], [3, 4], [5, 6], [7, 8]]
    y = [1, 2, 3, 4]

    model = ThunderSVM::Regressor.new(verbose: false)
    model.cv(x, y)
  end

  def test_numo
    # faster tests
    skip if ENV["APPVEYOR"]

    require "numo/narray"

    x = Numo::DFloat.cast([[1, 2], [3, 4], [5, 6], [7, 8]])
    y = Numo::Int32.cast([1, 1, 2, 2])

    model = ThunderSVM::Classifier.new
    model.fit(x, y)
    predictions = model.predict(x)
    expected = [1, 1, 2, 2]
    assert_equal expected, predictions
  end
end
