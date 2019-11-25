module ThunderSVM
  class Classifier < Model
    def initialize(svm_type: :c_svc, **options)
      super(svm_type: svm_type, **options)
    end
  end
end
