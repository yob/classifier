require 'classifier/naive_bayes'

RSpec.describe Classifier::NaiveBayes do
  let(:fake_store) { instance_double(Classifier::NaiveBayesMemoryStore) }

  before do
    allow(Classifier::NaiveBayesMemoryStore).to receive(:new) { fake_store }
  end

  describe "#initialize" do
    context "when passed 0 categories" do
      it "raises ArgumentError" do
        expect {
          Classifier::NaiveBayes.new(categories: [])
        }.to raise_error(ArgumentError, "need 2 or more categories")
      end
    end
    context "when passed 1 category" do
      it "raises ArgumentError" do
        expect {
          Classifier::NaiveBayes.new(categories: [:one])
        }.to raise_error(ArgumentError, "need 2 or more categories")
      end
    end
    context "when passed 2 categories" do
      it "raises no error" do
        expect {
          Classifier::NaiveBayes.new(categories: [:one, :two])
        }.to_not raise_error
      end
      it "creates a new memory store" do
        Classifier::NaiveBayes.new(categories: [:one, :two])
        expect(Classifier::NaiveBayesMemoryStore).to have_received(:new).once
      end
    end
    context "when passed 4 categories" do
      it "raises no error" do
        expect {
          Classifier::NaiveBayes.new(categories: [:one, :two, :three, :four])
        }.to_not raise_error
      end
      it "creates a new memory store" do
        Classifier::NaiveBayes.new(categories: [:one, :two, :three, :four])
        expect(Classifier::NaiveBayesMemoryStore).to have_received(:new).once
      end
    end
  end

  describe "#train" do
    context "with a pre-defined store" do
      context "with a valid category" do
        it "passes the training data to the store"
      end
      context "with an invalid category" do
        it "raises an exception"
      end
    end
  end

  describe "#classify" do
    context "with a pre-defined store" do
      it "returns a Classifier::Result instance with correct values"
    end
  end
end
