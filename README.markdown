Experiments in text classification, inspired by reading an [introduction to
Naive Bayes](https://monkeylearn.com/blog/practical-explanation-naive-bayes-classifier/).

My focus was on learning the fundamental algorithms rather than building a good
general purpose classification library. There are tools out there that are
suitable for real world use - this is not one of them.

## Usage

Basic naive bayes classification:

    require 'classifier'

    classifier = Classifier::NaiveBayes.new(categories: ["spam", "ham"])
    classifier.train("spam", "cheap", "viagra")
    classifier.train("ham", "cheap", "fruit")
    puts classifier.classify("fruit").inspect

To test the performance of a classifier, first build a CSV data file like this:

    category1,feature1,feature2
    category2,feature1,feature3

Then run the test harness:

    ruby -I lib bin/classify-nb input.csv

To run multiple files through the test harness:

    find . -name "input*.csv" | xargs -L1 ruby -I lib bin/classify-nb

## Specs

There are a number of specs that demonstrate intended behaviour. You can run them via rspec:

    bundle exec rspec --format doc

## TODO

* expand README with more examples
  * text classification: tokenisation, stemming, stop words, etc
  * feature selection
  * writing a custom store
* should we accept training data with no features?
* should we attempt to classify with no features?
* add a threshold so classification my a small margin can be flagged or ignored
* allow a doc_id to be included with training data, and re-training with the same doc_id will update data
* consider adding a way for documents to be removed from a store
