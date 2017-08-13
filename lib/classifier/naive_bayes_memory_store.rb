require 'bigdecimal'
require 'classifier/result'

module Classifier
  class NaiveBayesMemoryStore
    def initialize(categories)
      @data = {}
      @features = {}
      categories.each do |category|
        @data[category] = []
        @features[category] = Hash.new(0)
      end
    end

    def add_document(category, features)
      @data[category] << features
      features.each do |feature|
        @features[category][feature] += 1
      end
    end

    def categories
      @data.keys
    end

    def count_feature_in_category(category, feature)
      BigDecimal.new(
        @features.fetch(category).fetch(feature, 0)
      )
    end

    def total_features_in_category(category)
      @features.fetch(category).values.inject(BigDecimal.new(0)) { |accum, count| accum += count }
    end
    
    def total_uniq_features
      BigDecimal.new(
        @features.values.map(&:keys).flatten.uniq.size
      )
    end

    def documents_in_category(category)
      BigDecimal.new(@data.fetch(category).size)
    end

    def total_documents
      BigDecimal.new(
        @data.map { |_,v| v.size }.inject(0) { |accum, count| accum += count }
      )
    end

  end
end
