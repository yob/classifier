require 'bigdecimal'
require 'classifier/result'
require 'set'

module Classifier
  class NaiveBayesMemoryStore
    attr_reader :count_documents

    def initialize
      @uniq_features = Set.new
      @category_features = {}
      @documents_in_category = Hash.new(0)
      @count_documents = BigDecimal.new(0)
    end

    def add_document(category, features)
      @count_documents += 1
      @documents_in_category[category] += 1
      @category_features[category] ||= Hash.new(0)
      features.each do |feature|
        @category_features[category][feature] += 1
        @uniq_features << feature
      end
    end

    def count_feature_in_category(category, feature)
      @category_features[category] ||= Hash.new(0)
      BigDecimal.new(
        @category_features.fetch(category).fetch(feature, 0)
      )
    end

    def count_features_in_category(category)
      @category_features[category] ||= Hash.new(0)
      @category_features.fetch(category).values.inject(BigDecimal.new(0)) { |accum, count|
        accum += count
      }
    end
    
    def count_uniq_features
      BigDecimal.new(@uniq_features.size)
    end

    def count_documents_in_category(category)
      BigDecimal.new(@documents_in_category.fetch(category))
    end

  end
end
