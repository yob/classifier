require 'bigdecimal'
require 'classifier/result'
require 'securerandom'

module Classifier
  class NaiveBayesSequelStore

    def initialize(db, table_name)
      @db = db
      @table_name = table_name
      @db[@table_name].delete # TODO remove
    end

    def add_document(category, features)
      doc_id = SecureRandom.uuid
      features.each do |feature|
        @db[@table_name].insert(doc_id: doc_id, category: category.to_s, feature: feature.to_s)
      end
    end

    def count_documents
      BigDecimal.new(
        @db[@table_name].count(Sequel.lit("distinct doc_id"))
      )
    end

    def count_feature_in_category(category, feature)
      BigDecimal.new(
        @db[@table_name].where(category: category.to_s, feature: feature.to_s).count
      )
    end

    def count_features_in_category(category)
      BigDecimal.new(
        @db[@table_name].where(category: category.to_s).count
      )
    end

    def count_uniq_features
      BigDecimal.new(
        @db[@table_name].count(Sequel.lit("distinct feature"))
      )
    end

    def count_documents_in_category(category)
      BigDecimal.new(
        @db[@table_name].where(category: category.to_s).count(Sequel.lit("distinct doc_id"))
      )
    end
  end
end
