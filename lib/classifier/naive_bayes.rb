require 'bigdecimal'
require 'classifier/result'

module Classifier
  class NaiveBayes

    attr_reader :data, :words, :priori

    def initialize(*categories)
      raise ArgumentError, "need 2 or more categories" if categories.size < 2
      @data = {}
      @priori = {}
      @words = {}
      categories.each do |category|
        @data[category.to_sym] = []
        @priori[category.to_sym] = 0
        @words[category.to_sym] = Hash.new(0)
      end
    end

    def train(category, text)
      raise ArgumentError, "invalid category" unless @words.has_key?(category)
      
      @data[category] << text.to_s.downcase.strip
      text.split(/\s+/).each do |word|
        @words[category][word.downcase] += 1
      end
      calc_priori
    end

    def classify(text)
      probabilities = {}
      categories.each { |cat| probabilities[cat] = @priori.fetch(cat) }
      text.to_s.downcase.strip.split(/\s+/).each do |word|
        categories.each do |category|
          word_probability = (count_word_in_category(category, word) + 1) / (total_words_in_category(category) + total_uniq_words)
          probabilities[category] *= word_probability
        end
      end
      Classifier::Result.new(probabilities)
    end

    private

    def categories
      @data.keys
    end

    def count_word_in_category(category, word)
      BigDecimal.new(
        @words.fetch(category).fetch(word, 0)
      )
    end
    
    def total_words_in_category(category)
      @words.fetch(category).values.inject(BigDecimal.new(0)) { |accum, count| accum += count }
    end
    
    def total_uniq_words
      BigDecimal.new(
        @words.values.map(&:keys).flatten.uniq.size
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
