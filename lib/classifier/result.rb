module Classifier
  class Result
    attr_reader :category, :scores

    def initialize(probabilities)
      @scores = probabilities
      @category = calc_winning_category
      @runner_up = calc_runner_up
    end

    def inspect
      "<Classifier::Result:#{object_id} category: #{category} ratio: #{ratio.to_s('F')} scores: {#{rounded_scores}}>"
    end

    def ratio
      winning_score = @scores[@category]
      runner_up_score = @scores[@runner_up]
      (winning_score / runner_up_score).round(10)
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

    def calc_runner_up
      @scores.to_a.sort_by { |cat, score|
        score
      }[-2].first
    end

  end
end
