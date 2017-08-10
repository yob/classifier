module Classifier
  class Result
    attr_reader :category, :scores

    def initialize(probabilities)
      @scores = probabilities
      @category = calc_winning_category
    end

    def inspect
      "<Classifier::Result:#{object_id} category: #{category} scores: {#{rounded_scores}}>"
    end

    private

    def rounded_scores
      @scores.inject([]) do |accum, row|
        category, score = *row
        accum << "#{category}: #{score.round(25).to_s('F')}"
      end.join(", ")
    end

    def calc_winning_category
      @scores.to_a.sort_by { |cat, score|
        score
      }.last.first
    end

  end
end
