require 'classifier/naive_bayes_memory_store'

RSpec.describe Classifier::NaiveBayesMemoryStore do

  let(:monkey_store) { Classifier::NaiveBayesMemoryStore.new }
  let(:retrained_store) { Classifier::NaiveBayesMemoryStore.new }

  before do
    monkey_store.add_document(1, :sports, %w{A great game})
    monkey_store.add_document(2, :not_sports, %w{The election was over})
    monkey_store.add_document(3, :sports, %w{Very clean match})
    monkey_store.add_document(4, :sports, %w{A clean but forgettable game})
    monkey_store.add_document(5, :not_sports, %w{It was a close election})


    retrained_store.add_document(1, :sports, %w{A great game})
    retrained_store.add_document(2, :not_sports, %w{The election was over})
    retrained_store.add_document(3, :sports, %w{Very clean match})
    retrained_store.add_document(1, :not_sports, %w{A great game})
  end

  describe "#count_documents" do
    context "with monkey learn data" do
      it "returns a BigDecimal" do
        expect(monkey_store.count_documents).to be_a(BigDecimal)
      end
      it "returns a count of all documents" do
        expect(monkey_store.count_documents).to eq(5)
      end
    end
    context "with retrained data" do
      it "returns a BigDecimal" do
        expect(retrained_store.count_documents).to be_a(BigDecimal)
      end
      it "returns a count of all documents" do
        expect(retrained_store.count_documents).to eq(3)
      end
    end
  end

  describe "#count_documents_in_category" do
    context "with monkey learn data" do
      it "returns a BigDecimal" do
        expect(monkey_store.count_documents_in_category(:sports)).to be_a(BigDecimal)
      end
      it "returns a count of documents in category" do
        expect(monkey_store.count_documents_in_category(:sports)).to eq(3)
        expect(monkey_store.count_documents_in_category(:not_sports)).to eq(2)
      end
    end
    context "with retrained data" do
      it "returns a BigDecimal" do
        expect(retrained_store.count_documents_in_category(:sports)).to be_a(BigDecimal)
      end
      it "returns a count of documents in category" do
        expect(retrained_store.count_documents_in_category(:sports)).to eq(1)
        expect(retrained_store.count_documents_in_category(:not_sports)).to eq(2)
      end
    end
  end

  describe "#count_feature_in_category" do
    context "with monkey learn data" do
      it "returns a BigDecimal" do
        expect(monkey_store.count_feature_in_category(:sports, "game")).to be_a(BigDecimal)
      end
      it "returns the number of documents in a category that have feature" do
        expect(monkey_store.count_feature_in_category(:sports, "game")).to eq(2)
        expect(monkey_store.count_feature_in_category(:not_sports, "close")).to eq(1)
      end
    end
    context "with retrained data" do
      it "returns a BigDecimal" do
        expect(retrained_store.count_feature_in_category(:sports, "game")).to be_a(BigDecimal)
      end
      it "returns the number of documents in a category that have feature" do
        expect(retrained_store.count_feature_in_category(:sports, "game")).to eq(0)
        expect(retrained_store.count_feature_in_category(:not_sports, "game")).to eq(1)
        expect(retrained_store.count_feature_in_category(:not_sports, "election")).to eq(1)
      end
    end
  end

  describe "#count_features_in_category" do
    context "with monkey learn data" do
      it "returns a BigDecimal" do
        expect(monkey_store.count_features_in_category(:sports)).to be_a(BigDecimal)
      end
      it "returns the number of features for all documents in a category" do
        expect(monkey_store.count_features_in_category(:sports)).to eq(11)
        expect(monkey_store.count_features_in_category(:not_sports)).to eq(9)
      end
    end
    context "with retrained data" do
      it "returns a BigDecimal" do
        expect(retrained_store.count_features_in_category(:sports)).to be_a(BigDecimal)
      end
      it "returns the number of features for all documents in a category" do
        expect(retrained_store.count_features_in_category(:sports)).to eq(3)
        expect(retrained_store.count_features_in_category(:not_sports)).to eq(7)
      end
    end
  end

  describe "#count_uniq_features" do
    context "with monkey learn data" do
      it "returns a BigDecimal" do
        expect(monkey_store.count_uniq_features).to be_a(BigDecimal)
      end
      it "returns the number of uniq features for all documents in all categories" do
        expect(monkey_store.count_uniq_features).to eq(15)
      end
    end
    context "with retrained data" do
      it "returns a BigDecimal" do
        expect(retrained_store.count_uniq_features).to be_a(BigDecimal)
      end
      it "returns the number of uniq features for all documents in all categories" do
        expect(retrained_store.count_uniq_features).to eq(10)
      end
    end
  end
end
