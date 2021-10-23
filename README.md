# ThunderSVM Ruby

[ThunderSVM](https://github.com/Xtra-Computing/thundersvm) - high performance parallel SVMs - for Ruby

:fire: Uses GPUs and multi-core CPUs for blazing performance

For a great intro on support vector machines, check out [this video](https://www.youtube.com/watch?v=efR1C6CvhmE).

[![Build Status](https://github.com/ankane/thundersvm-ruby/workflows/build/badge.svg?branch=master)](https://github.com/ankane/thundersvm-ruby/actions)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'thundersvm'
```

On Mac, also install OpenMP:

```sh
brew install libomp
```

## Getting Started

Prep your data

```ruby
x = [[1, 2], [3, 4], [5, 6], [7, 8]]
y = [1, 2, 3, 4]
```

Train a model

```ruby
model = ThunderSVM::Regressor.new
model.fit(x, y)
```

Use `ThunderSVM::Classifier` for classification and `ThunderSVM::Model` for other models

Make predictions

```ruby
model.predict(x)
```

Save the model to a file

```ruby
model.save_model("model.txt")
```

Load the model from a file

```ruby
model = ThunderSVM.load_model("model.txt")
```

Get support vectors

```ruby
model.support_vectors
```

## Cross-Validation

Perform cross-validation

```ruby
model.cv(x, y)
```

Specify the number of folds

```ruby
model.cv(x, y, folds: 5)
```

## Parameters

Defaults shown below

```ruby
ThunderSVM::Model.new(
  svm_type: :c_svc,    # type of SVM (c_svc, nu_svc, one_class, epsilon_svr, nu_svr)
  kernel: :rbf,        # type of kernel function (linear, polynomial, rbf, sigmoid)
  degree: 3,           # degree in kernel function
  gamma: nil,          # gamma in kernel function
  coef0: 0,            # coef0 in kernel function
  c: 1,                # parameter C of C-SVC, epsilon-SVR, and nu-SVR
  nu: 0.5,             # parameter nu of nu-SVC, one-class SVM, and nu-SVR
  epsilon: 0.1,        # epsilon in loss function of epsilon-SVR
  max_memory: 8192,    # constrain the maximum memory size (MB) that thundersvm uses
  tolerance: 0.001,    # tolerance of termination criterion
  probability: false,  # whether to train a SVC or SVR model for probability estimates
  gpu: 0,              # specify which gpu to use
  cores: nil,          # number of cpu cores to use (defaults to all)
  verbose: false       # verbose mode
)
```

## Data

Data can be a Ruby array

```ruby
[[1, 2], [3, 4], [5, 6], [7, 8]]
```

Or a Numo array

```ruby
Numo::DFloat.cast([[1, 2], [3, 4], [5, 6], [7, 8]])
```

Or the path a file in `libsvm` format (better for sparse data)

```ruby
model.fit("train.txt")
model.predict("test.txt")
```

## GPUs

To run ThunderSVM on GPUs, you’ll need to build the library from source.

### Linux

```sh
git clone --recursive --branch v0.3.4 https://github.com/Xtra-Computing/thundersvm
cd thundersvm
mkdir build
cd build
cmake ..
make
```

Specify the path to the shared library with:

```ruby
ThunderSVM.ffi_lib = "path/to/build/lib/libthundersvm.so"
```

### Windows

Follow the [official instructions](https://thundersvm.readthedocs.io/en/latest/get-started.html#installation-for-windows). Specify the path to the shared library with:

```ruby
ThunderSVM.ffi_lib = "path/to/build/lib/libthundersvm.dll"
```

## Resources

- [ThunderSVM: A Fast SVM Library on GPUs and CPUs](https://github.com/Xtra-Computing/thundersvm/blob/master/thundersvm-full.pdf)
- [A Practical Guide to Support Vector Classification](https://www.csie.ntu.edu.tw/~cjlin/papers/guide/guide.pdf)

## History

View the [changelog](https://github.com/ankane/thundersvm-ruby/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/thundersvm-ruby/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/thundersvm-ruby/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/thundersvm-ruby.git
cd thundersvm-ruby
bundle install
bundle exec rake test
```
