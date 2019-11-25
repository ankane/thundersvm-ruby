module ThunderSVM
  class Regressor < Model
    def initialize(svm_type: :epsilon_svr, **options)
      super(svm_type: svm_type, **options)
    end
  end
end
