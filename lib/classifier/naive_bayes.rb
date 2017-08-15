require 'bigdecimal'
require 'classifier/result'
require 'classifier/naive_bayes_memory_store'

module Classifier
  class NaiveBayes

    def initialize(*categories)
      raise ArgumentError, "need 2 or more categories" if categories.size < 2
      @store = NaiveBayesMemoryStore.new(categories)
    end

    def train(category, *features)
      raise ArgumentError, "invalid category" unless @store.categories.include?(category)

      @store.add_document(category, filter(features))
    end

    def classify(*candidate_features)
      probabilities = {}
      @store.categories.each { |cat| probabilities[cat] = calc_priori(cat) }
      filter(candidate_features).each do |feature|
        @store.categories.each do |category|
          feature_probability = (
            @store.count_feature_in_category(category, feature) + 1
          ) / (
            @store.count_features_in_category(category) + @store.count_uniq_features
          )

          probabilities[category] *= feature_probability
        end
      end
      Classifier::Result.new(probabilities)
    end

    private

    def filter(features)
      features.flatten.map { |f|
        f.to_s.downcase.strip
      }.reject { |f|
        f.nil? || f == "".freeze
      }
    end

    def calc_priori(category)
      @store.count_documents_in_category(category) / @store.count_documents
    end

  end
end
