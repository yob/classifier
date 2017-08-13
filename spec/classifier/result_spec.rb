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

  describe "#inspect" do
    it "returns the correct string" do
      expect(result.inspect).to match(
        /\A<Classifier::Result:\d+ category: catone scores: {catone: 0.5, cattwo: 0.2}>\Z/
      )
    end
  end
end
