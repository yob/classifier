require 'classifier/naive_bayes_memory_store'

RSpec.describe Classifier::NaiveBayesMemoryStore do

  let(:monkey_store) { Classifier::NaiveBayesMemoryStore.new }

  before do
    monkey_store.add_document(1, :sports, %w{A great game})
    monkey_store.add_document(2, :not_sports, %w{The election was over})
    monkey_store.add_document(3, :sports, %w{Very clean match})
    monkey_store.add_document(4, :sports, %w{A clean but forgettable game})
    monkey_store.add_document(5, :not_sports, %w{It was a close election})
  end

  describe "#count_documents" do
    it "returns a BigDecimal" do
      expect(monkey_store.count_documents).to be_a(BigDecimal)
    end
    it "returns a count of all documents" do
      expect(monkey_store.count_documents).to eq(5)
    end
  end

  describe "#count_documents_in_category" do
    it "returns a BigDecimal" do
      expect(monkey_store.count_documents_in_category(:sports)).to be_a(BigDecimal)
    end
    it "returns a count of documents in category" do
      expect(monkey_store.count_documents_in_category(:sports)).to eq(3)
      expect(monkey_store.count_documents_in_category(:not_sports)).to eq(2)
    end
  end

  describe "#count_feature_in_category" do
    it "returns a BigDecimal" do
      expect(monkey_store.count_feature_in_category(:sports, "game")).to be_a(BigDecimal)
    end
    it "returns the number of documents in a category that have feature" do
      expect(monkey_store.count_feature_in_category(:sports, "game")).to eq(2)
      expect(monkey_store.count_feature_in_category(:not_sports, "close")).to eq(1)
    end
  end

  describe "#count_features_in_category" do
    it "returns a BigDecimal" do
      expect(monkey_store.count_features_in_category(:sports)).to be_a(BigDecimal)
    end
    it "returns the number of features for all documents in a category" do
      expect(monkey_store.count_features_in_category(:sports)).to eq(11)
      expect(monkey_store.count_features_in_category(:not_sports)).to eq(9)
    end
  end

  describe "#count_uniq_features" do
    it "returns a BigDecimal" do
      expect(monkey_store.count_uniq_features).to be_a(BigDecimal)
    end
    it "returns the number of uniq features for all documents in all categories" do
      expect(monkey_store.count_uniq_features).to eq(15)
    end
  end
end
