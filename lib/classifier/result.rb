module Classifier
  class Result
    attr_reader :category

    def initialize(probabilities)
      @probabilities = probabilities
      @category = calc_winning_category
    end

    def inspect
      "<Classifier::Result:#{object_id} category: #{category} scores: {#{scores}}>"
    end

    def scores
      @probabilities.inject([]) do |accum, row|
        category, score = *row
        accum << "#{category}: #{score.round(10).to_s('F')}"
      end.join(", ")
    end

    private

    def calc_winning_category
      @probabilities.to_a.sort_by { |cat, score|
        score
      }.last.first
    end

  end
end
