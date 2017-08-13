require 'classifier/naive_bayes'

RSpec.describe Classifier::NaiveBayes do
  let(:fake_store) { instance_double(Classifier::NaiveBayesMemoryStore) }

  before do
    allow(Classifier::NaiveBayesMemoryStore).to receive(:new) { fake_store }
  end

  describe "#initialize" do
    context "when passed 0 arguments" do
      it "raises ArgumentError" do
        expect {
          Classifier::NaiveBayes.new
        }.to raise_error(ArgumentError, "need 2 or more categories")
      end
    end
    context "when passed 1 arguments" do
      it "raises ArgumentError" do
        expect {
          Classifier::NaiveBayes.new(:one)
        }.to raise_error(ArgumentError, "need 2 or more categories")
      end
    end
    context "when passed 2 arguments" do
      it "raises no error" do
        expect {
          Classifier::NaiveBayes.new(:one, :two)
        }.to_not raise_error
      end
      it "creates a new memory store" do
        Classifier::NaiveBayes.new(:one, :two)
        expect(Classifier::NaiveBayesMemoryStore).to have_received(:new).once.with([:one, :two])
      end
    end
    context "when passed 4 arguments" do
      it "raises no error" do
        expect {
          Classifier::NaiveBayes.new(:one, :two, :three, :four)
        }.to_not raise_error
      end
      it "creates a new memory store" do
        Classifier::NaiveBayes.new(:one, :two, :three, :four)
        expect(Classifier::NaiveBayesMemoryStore).to have_received(:new).once.with([:one, :two, :three, :four])
      end
    end
  end

end
