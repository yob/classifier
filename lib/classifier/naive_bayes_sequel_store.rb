require 'bigdecimal'
require 'classifier/result'
require 'securerandom'

module Classifier
  class NaiveBayesSequelStore

    def initialize(db, table_name, categories)
      @db = db
      @table_name = table_name
      @db[@table_name].delete # TODO remove
      @categories = categories
      reset_cache
    end

    def reset_cache
      @count_documents_cache = nil
      @count_uniq_features_cache = nil
      @count_feature_in_category_cache = Hash.new
      @count_features_in_category_cache = Hash.new
      @count_documents_in_category_cache = Hash.new
    end

    def add_document(category, features)
      doc_id = SecureRandom.uuid
      features.each do |feature|
        @db[@table_name].insert(doc_id: doc_id, category: category.to_s, feature: feature.to_s)
      end
      reset_cache
    end

    # TODO can we load this from the DB?
    def categories
      @categories 
    end
    
    def count_documents
      @count_documents_cache ||= BigDecimal.new(
        @db[@table_name].count("distinct doc_id")
      )
    end

    def count_feature_in_category(category, feature)
      @count_feature_in_category_cache["#{category}-#{feature}"] ||= BigDecimal.new(
        @db[@table_name].where(category: category.to_s, feature: feature.to_s).count
      )
    end

    def count_features_in_category(category)
      @count_features_in_category_cache[category] ||= BigDecimal.new(
        @db[@table_name].where(category: category.to_s).count("distinct feature")
      )
    end
    
    def count_uniq_features
      @count_uniq_features_cache ||= BigDecimal.new(
        @db[@table_name].count("distinct feature")
      )
    end

    def count_documents_in_category(category)
      @count_documents_in_category_cache[category] ||= BigDecimal.new(
        @db[@table_name].where(category: category.to_s).count("distinct doc_id")
      )
    end
  end
end
