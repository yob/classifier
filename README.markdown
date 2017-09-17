Experiments in text classification, inspired by reading an [introduction to
Naive Bayes](https://monkeylearn.com/blog/practical-explanation-naive-bayes-classifier/).

My focus was on learning the fundamental algorithms rather than building a good
general purpose classification library. There are tools out there that are
suitable for real world use - this is not one of them.

## Usage

Basic naive bayes classification:

    require 'classifier'

    classifier = Classifier::NaiveBayes.new(categories: ["spam", "ham"])
    classifier.train(category: "spam", features: ["cheap", "viagra"])
    classifier.train(category: "ham", features: ["cheap", "fruit"])
    puts classifier.classify("fruit").inspect

### Retraining

An optional `doc_id` argument can be provided to the train method. On the
second and subsequent times a `doc_id` is provided, the existing data for that
document is replaced.

This allows for workflows where a human might re-classify documents over time.

    classifier = Classifier::NaiveBayes.new(categories: ["spam", "ham"])
    classifier.train(doc_id: "1", category: "spam", features: ["fruit", "vegetables"])
    classifier.train(doc_id: "2", category: "spam", features: ["cheap", "viagra"])
    classifier.train(doc_id: "3", category: "ham", features: ["cheap", "fruit"])
    classifier.train(doc_id: "1", category: "ham", features: ["fruit", "vegetables"])
    puts classifier.classify("fruit").inspect

### Testing Classifier Accuracy

To test the performance of a classifier, first build a CSV data file with human
classified features like this:

    category1,feature1,feature2
    category2,feature1,feature3

Then run the test harness:

    ruby -I lib bin/classify-nb input.csv

To run multiple files through the test harness:

    find . -name "input*.csv" | xargs -L1 ruby -I lib bin/classify-nb

### Custom Persistence

By default, classifier data is stored in memory and will be lost when the ruby
process ends. That's probably fine for experimenting, but to use a classifier
in a real-world situation you'll likely want to store the data somewhere persistent
like a database or file.

    my_store = MyCustomStore.new
    classifier = Classifier::NaiveBayes.new(store: my_store, categories: ["spam", "ham"])
    classifier.train(category: "spam", features: ["cheap", "viagra"])
    classifier.train(category: "ham", features: ["cheap", "fruit"])
    puts classifier.classify("fruit").inspect

A store object MUST implement the following contract.

    # Stores a new document. The return value is ignored.
    add_document(doc_id, category, features)

    # Return an BigDecimal that indicates the number of times 'feature' occured
    # in documents classified in 'category'
    count_feature_in_category(category, feature)

    # Return an BigDecimal that indicates the total number of features in documents
    # classified in 'category'
    count_features_in_category(category)

    # Return a BigDecimal that inidicates the number of unique features seen in
    # any document from all categories
    count_uniq_features

    # Return a BigDecimal indicating the number of documents that have been
    # classified in 'category'
    count_documents_in_category(category)

    # Return a BigDecimal indicating the number of documents that have been
    # classified in any category
    count_documents

A sample store that persists to a database using the `sequel` gem is also available:

    require 'classifier'
    require 'classifier/naive_bayes_sequel_store'

    db = Sequel.connect(ENV["DATABASE_URL"])
    db_store = Classifier::NaiveBayesSequelStore.new(db, :naive_bayes_table)
    classifier = Classifier::NaiveBayes.new(store: db_store, categories: ["spam", "ham"])
    classifier.train(category: "spam", features: ["cheap", "viagra"])
    classifier.train(category: "ham", features: ["cheap", "fruit"])
    puts classifier.classify("fruit").inspect

The behaviour of your custom store must be accurate, or the classifier will produce
inaccurate results. It's recommended that you write tests for the store that compare
it's behaviour to the reference in-memory store: `Classifier::NaiveBayesMemoryStore`.

## Specs

There are a number of specs that demonstrate intended behaviour. You can run them via rspec:

    bundle exec rspec --format doc

## TODO

* add a threshold so classification my a small margin can be flagged or ignored
* expand README with more examples
  * text classification: tokenisation, stemming, stop words, etc
  * feature selection
  * writing a custom store
* should we accept training data with no features?
* should we attempt to classify with no features?
* consider adding a way for documents to be removed from a store
