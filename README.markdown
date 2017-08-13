Experiments in text classification, inspired by reading an [introduction to
Naive Bayes](https://monkeylearn.com/blog/practical-explanation-naive-bayes-classifier/).

My focus was on learning the fundamental algorithms rather than building a good
general purpose classification library. There are tools out there that are
suitable for real world use - this is not one of them.

## Usage

Basic naive bayes classification:

    require 'classifier'

    classifier = Classifier::NaiveBayes.new("spam", "ham")
    classifier.train("spam", "cheap", "viagra")
    classifier.train("ham", "cheap", "fruit")
    puts classifier.classify("fruit"),inspect

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

* Adjust Classifier::NaiveBayes to allow a store to be passed in
* Build a demonstration postgres store
* Improve consistency fo method names required by store contract. count/total, etc
* expand README with more examples
  * text classification: tokenisation, stemming, stop words, etc
  * feature selection
  * writing a custom store
* consider adding a way for documents to be removed from a store
