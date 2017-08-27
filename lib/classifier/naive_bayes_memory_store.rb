require 'bigdecimal'
require 'classifier/result'
require 'set'

module Classifier
  class NaiveBayesMemoryStore

    class Record
      attr_reader :doc_id, :category, :feature

      def initialize(doc_id, category, feature)
        @doc_id = doc_id.to_s.freeze
        @category = category.to_s.freeze
        @feature = feature.to_s.freeze
      end
    end

    def initialize
      @records = []
    end

    def add_document(doc_id, category, features)
      doc_id = doc_id.to_s
      category = category.to_s

      @records.delete_if { |record|
        record.doc_id == doc_id
      }
      features.each do |feature|
        @records << Record.new(doc_id, category, feature)
      end
    end

    def count_feature_in_category(category, feature)
      category = category.to_s
      feature = feature.to_s

      count = @records.select { |record|
        record.category == category && record.feature == feature
      }.size
      BigDecimal.new(count)
    end

    def count_features_in_category(category)
      category = category.to_s

      count = @records.select { |record|
        record.category == category
      }.size
      BigDecimal.new(count)
    end
    
    def count_uniq_features
      count = @records.map { |record|
        record.feature
      }.uniq.size
      BigDecimal.new(count)
    end

    def count_documents_in_category(category)
      category = category.to_s

      count = @records.select { |record|
        record.category == category
      }.map { |record|
        record.doc_id
      }.uniq.size
      BigDecimal.new(count)
    end

    def count_documents
      count = @records.map { |record|
        record.doc_id
      }.uniq.size
      BigDecimal.new(count)
    end

  end
end
