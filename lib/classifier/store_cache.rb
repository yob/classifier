require 'bigdecimal'
require 'classifier/result'

module Classifier
  # Wrap this around a Store instance to have the return values memoised.
  class StoreCache
    def initialize(store)
      @store = store
      reset_cache
    end

    def add_document(doc_id, category, features)
      @store.add_document(doc_id, category, features)
      reset_cache
    end

    def count_documents
      @count_documents_cache ||= @store.count_documents
    end

    def count_feature_in_category(category, feature)
      @count_feature_in_category_cache["#{category}-#{feature}"] ||=
        @store.count_feature_in_category(category, feature)
    end

    def count_features_in_category(category)
      @count_features_in_category_cache[category] ||= @store.count_features_in_category(category)
    end

    def count_uniq_features
      @count_uniq_features_cache ||= @store.count_uniq_features
    end

    def count_documents_in_category(category)
      @count_documents_in_category_cache[category] ||= @store.count_documents_in_category(category)
    end

    private

    def reset_cache
      @count_documents_cache = nil
      @count_uniq_features_cache = nil
      @count_feature_in_category_cache = Hash.new
      @count_features_in_category_cache = Hash.new
      @count_documents_in_category_cache = Hash.new
    end
  end
end
