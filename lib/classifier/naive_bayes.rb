require 'bigdecimal'
require 'classifier/result'

module Classifier
  class NaiveBayes

    attr_reader :data, :words, :priori

    def initialize(*categories)
      raise ArgumentError, "need 2 or more categories" if categories.size < 2
      @data = {}
      @priori = {}
      @features = {}
      categories.each do |category|
        @data[category] = []
        @priori[category] = 0
        @features[category] = Hash.new(0)
      end
    end

    def train(category, *features)
      raise ArgumentError, "invalid category" unless @features.has_key?(category)
      
      features = filter(features)

      @data[category] << features
      features.each do |feature|
        @features[category][feature] += 1
      end
      calc_priori
    end

    def classify(*candidate_features)
      probabilities = {}
      categories.each { |cat| probabilities[cat] = @priori.fetch(cat) }
      filter(candidate_features).each do |feature|
        categories.each do |category|
          feature_probability = (count_feature_in_category(category, feature) + 1) / (total_features_in_category(category) + total_uniq_features)
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

    def calc_priori
      total_strings = @data.map { |_,v| v.size }.inject(0) { |accum, count| accum += count }
      @data.each do |category, strings|
        @priori[category] = BigDecimal.new(strings.size) / total_strings
      end
    end
  end
end
