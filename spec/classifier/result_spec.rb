require 'classifier/result'
require 'bigdecimal'

RSpec.describe Classifier::Result do
  let(:probabilities) {
    {
      catone: BigDecimal.new("0.5"),
      cattwo: BigDecimal.new("0.2")
    }
  }
  let(:result) { Classifier::Result.new(probabilities)}

  describe "#category" do
    it "returns the category with the higest probability" do
      expect(result.category).to eq(:catone)
    end
  end

  describe "#scores" do
    it "returns the scores for all categories" do
      expect(result.scores).to eq(probabilities)
    end
  end

  describe "#ratio" do
    it "returns the number of times the runner up score must be multiplied to equal the winning score" do
      expect(result.ratio).to eq(BigDecimal.new("2.5"))
    end
  end

  describe "#inspect" do
    it "returns the correct string" do
      expect(result.inspect).to match(
        /\A<Classifier::Result:\d+ category: catone ratio: 2.5 scores: {catone: 0.5, cattwo: 0.2}>\Z/
      )
    end
  end
end
