require 'classifier/naive_bayes'
require 'pp'

RSpec.describe Classifier::NaiveBayes do
  let(:classifier) { Classifier::NaiveBayes.new(:sports, :not_sports) }

  context "with monkey learn data" do
    before do
      classifier.train(:sports, "A great game")
      classifier.train(:not_sports, "The election was over")
      classifier.train(:sports, "Very clean match")
      classifier.train(:sports, "A clean but forgettable game")
      classifier.train(:not_sports, "It was a close election")
    end

    context "with a sport result input" do
      let(:result) { classifier.classify("a very close game") }

      it "classifies a string as sports" do
        expect(result.category).to eq(:sports) 
      end
    end
  end
end
