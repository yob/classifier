require 'classifier'
require 'classifier/naive_bayes_sequel_store'
require 'sequel'
require 'pg'

RSpec.describe "Classifier::NaiveBayes with a sequel store" do

  context "with monkey learn data" do
    let(:classifier) {
      db = Sequel.connect("postgres://%2Fvar%2Frun%2Fpostgresql/naive-bayes-experiment")
      db[:nb].delete
      store = Classifier::NaiveBayesSequelStore.new(db, :nb, [:sports, :not_sports])
      classifier = Classifier::NaiveBayes.new(store: store, categories: [:sports, :not_sports]) 
    }

    before do
      classifier.train(:sports, %w{A great game})
      classifier.train(:not_sports, %w{The election was over})
      classifier.train(:sports, %w{Very clean match})
      classifier.train(:sports, %w{A clean but forgettable game})
      classifier.train(:not_sports, %w{It was a close election})
    end

    context "with a sport result input" do
      let(:result) { classifier.classify(%w{a very close game}) }

      it "classifies a string as sports" do
        expect(result.category).to eq(:sports)
      end

      it "calculates correct scores" do
        expect(result.scores).to be_a(Hash)
        expect(result.scores.size).to eq(2)
        expect(result.scores[:sports].round(10)).to eq(BigDecimal.new("0.000027648"))
        expect(result.scores[:not_sports].round(10)).to eq(BigDecimal.new("0.0000057175"))
      end
    end
  end
end
