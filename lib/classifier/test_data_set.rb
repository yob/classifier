module Classifier
  class TestDataSet
    def initialize(name, classifier)
      @name = name
      @classifier = classifier
    end

    # data is an Array of Arrays. The first item of each row is the category, the remaining items
    # are features
    def test(data)
      train_clasifier(data)

      match = 0
      nomatch = 0

      data.each do |row|
        category = row.first
        features = row[1..100]
        result = @classifier.classify(*features)
        if result.category == category
          match += 1
        else
          nomatch += 1
        end
      end

      puts "#{@name}: matched #{match}/#{match+nomatch} (#{percentage(match, match + nomatch).to_s("F")}%)"
    end

    private

    def train_clasifier(data)
      data.each do |row|
        category = row.first
        features = row[1..100]
        @classifier.train(category, *features)
      end
    end

    def percentage(num, total)
      num = BigDecimal.new(num.to_s)
      total = BigDecimal.new(total.to_s)
      (num / total * 100).round(3)
    end
  end
end
