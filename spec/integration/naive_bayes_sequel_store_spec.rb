require 'classifier'
require 'classifier/naive_bayes_sequel_store'
require 'sequel'
require 'pg'

RSpec.describe "Classifier::NaiveBayes with a sequel store", db: true do

  context "with monkey learn data" do
    let(:classifier) {
      db = Sequel.connect(ENV["DATABASE_URL"])
      store = Classifier::NaiveBayesSequelStore.new(db, :nb)
      classifier = Classifier::NaiveBayes.new(store: store, categories: [:sports, :not_sports])
    }

    before do
      classifier.train(category: :sports, features: %w{A great game})
      classifier.train(category: :not_sports, features: %w{The election was over})
      classifier.train(category: :sports, features: %w{Very clean match})
      classifier.train(category: :sports, features: %w{A clean but forgettable game})
      classifier.train(category: :not_sports, features: %w{It was a close election})
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

  context "with a doc_id is re-trained" do
    let(:classifier) {
      db = Sequel.connect(ENV["DATABASE_URL"])
      store = Classifier::NaiveBayesSequelStore.new(db, :nb)
      classifier = Classifier::NaiveBayes.new(store: store, categories: [:ham, :spam])
    }

    before do
      classifier.train(doc_id: "1", category: :spam, features: %w{Christmas Lunch})
      classifier.train(doc_id: "2", category: :ham, features: %w{Thanksgiving Lunch})
      classifier.train(doc_id: "3", category: :spam, features: %w{Viagra for Christmas})
      classifier.train(doc_id: "1", category: :ham, features: %w{Christmas Lunch})
    end

    context "with a ham input" do
      let(:result) { classifier.classify(%w{Birthday Lunch}) }

      it "classifies a string as sports" do
        expect(result.category).to eq(:ham)
      end

      it "calculates correct scores" do
        expect(result.scores).to be_a(Hash)
        expect(result.scores.size).to eq(2)
        expect(result.scores[:ham].round(10)).to eq(BigDecimal.new("0.024691358"))
        expect(result.scores[:spam].round(10)).to eq(BigDecimal.new("0.0052083333"))
      end
    end
  end
end
