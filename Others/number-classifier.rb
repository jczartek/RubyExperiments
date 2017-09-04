
module NumberClassifier
  class << self

    def factors(number)
      (1..number).find_all { |candidate| number % candidate == 0 }
    end

    def aliquotSum(number)
      factors(number).reduce(0, :+) - number
    end

    def perfect?(number)
      aliquotSum(number) == number
    end

    def abundant?(number)
      aliquotSum(number) > number
    end

    def deficient?(number)
      aliquotSum(number) < number
    end
  end
end
