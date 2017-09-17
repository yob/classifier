require 'bigdecimal'
require 'securerandom'
require 'classifier/result'
require 'classifier/naive_bayes_memory_store'
require 'classifier/store_cache'

module Classifier
  class NaiveBayes

    def initialize(store: nil, categories:)
      raise ArgumentError, "need 2 or more categories" if categories.size < 2
      @categories = categories
      @store = store || NaiveBayesMemoryStore.new
      @caching_store = StoreCache.new(@store)
    end

    def train(doc_id: nil, category:, features:)
      raise ArgumentError, "invalid category" unless @categories.include?(category)

      doc_id ||= SecureRandom.uuid
      @caching_store.add_document(
        doc_id.to_s,
        category.to_s,
        filter(features)
      )
    end

    def classify(*candidate_features)
      probabilities = {}
      @categories.each { |cat| probabilities[cat] = calc_priori(cat) }
      filter(candidate_features).each do |feature|
        @categories.each do |category|
          feature_probability = (
            @caching_store.count_feature_in_category(category, feature) + 1
          ) / (
            @caching_store.count_features_in_category(category) + @caching_store.count_uniq_features
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
      @caching_store.count_documents_in_category(category) / @caching_store.count_documents
    end

  end
end
