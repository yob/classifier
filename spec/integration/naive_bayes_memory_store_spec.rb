require 'classifier/naive_bayes'
require 'pp'

RSpec.describe "Classifier::NaiveBayes with a memory store" do

  context "with monkey learn data" do
    let(:classifier) { Classifier::NaiveBayes.new(categories: [:sports, :not_sports]) }

    before do
      classifier.train(category: :sports, features: %w{A great game})
      classifier.train(category: :not_sports, features: %w{The election was over})
      classifier.train(category: :sports, features: %w{Very clean match})
      classifier.train(category: :sports, features: %w{A clean but forgettable game})
      classifier.train(category: :not_sports, features: %w{It was a close election})
    end

    context "with a sport result input" do
      let(:result) { classifier.classify(%w{a very close game}) }

      it "classifies a string as sports" do
        expect(result.category).to eq(:sports)
      end

      it "calculates correct scores" do
        expect(result.scores).to be_a(Hash)
        expect(result.scores.size).to eq(2)
        expect(result.scores[:sports].round(10)).to eq(BigDecimal.new("0.000027648"))
        expect(result.scores[:not_sports].round(10)).to eq(BigDecimal.new("0.0000057175"))
      end
    end
  end

  context "with 4 Field Of Research codes and topic data from theconversation.com" do
    let(:classifier) { Classifier::NaiveBayes.new(categories: [:maths, :medical, :education, :law]) }

    before do
      # https://theconversation.com/teaching-maths-what-does-the-evidence-say-actually-works-64976
      classifier.train(category: :maths, features: ["Mathematics", "Education", "Schools", "Teaching", "Math anxiety", "Teaching maths", "academic performance", "Better Teachers"])
      # https://theconversation.com/eleven-games-and-activities-for-parents-to-encourage-maths-in-early-learning-76522
      classifier.train(category: :maths, features: ["Mathematics", "Learnin", "Early childhood education", "Parents", "Early childhood learning", "Parents role in education"])
      # https://theconversation.com/the-goldwater-rule-prevents-psychiatrists-diagnosing-trump-from-afar-but-some-say-theres-too-much-at-stake-81674
      classifier.train(category: :medical, features: ["Psychology", "Psychiatry", "US politics", "Sigmund Freud", "Psychotherapy", "attention deficit hyperactivity disorder", "Narcissism", "Donald Trump", "Diagnosis", "Barry Goldwater", "Psychoanalysis"])
      # https://theconversation.com/greg-hunts-plan-to-reduce-hospital-admissions-wont-work-if-he-cant-measure-successes-and-failures-81834
      classifier.train(category: :medical, features: ["COAG", "Health funding", "hospital funding", "Greg Hunt", "Health data", "health care policy"])
      # https://theconversation.com/weekly-dose-methylprednisolone-a-drug-for-treating-inflammation-but-not-rare-kidney-disease-81893
      classifier.train(category: :medical, features: ["Research", "Kidney disease", "Pharmaceuticals", "Arthritis", "Pharmacology", "Medication", "Asthma", "Side effects", "Corticosteroid", "Allergy", "Psoriasis", "Corticosteroids", "Weekly Dose"])
      # https://theconversation.com/to-empower-students-with-effective-writing-skills-handwriting-matters-81949
      classifier.train(category: :education, features: ["Children", "Teaching", "Primary education", "Secondary education", "NAPLAN", "Writing", "Primary school", "Handwriting", "Classrooms"])
      # https://theconversation.com/universities-have-a-problem-with-sexual-assault-and-harassment-heres-how-to-fix-it-81096
      classifier.train(category: :education, features: ["Relationships", "Violence", "Sexual harassment", "Australian universities", "Campus sexual assault"])
      # https://theconversation.com/artificial-intelligence-holds-great-potential-for-both-students-and-teachers-but-only-if-used-wisely-81024
      classifier.train(category: :education, features: ["Artificial intelligence", "Intelligence Technology", "Big data", "data", "Learning analytics"])
      # https://theconversation.com/explainer-what-is-fair-dealing-and-when-can-you-copy-without-permission-80745
      classifier.train(category: :law, features: ["Law", "Copyright", "Digital copyright", "Fair use", "Technology explainer"])
      # https://theconversation.com/factcheck-qanda-what-are-the-facts-on-funding-for-domestic-violence-legal-services-in-australia-69214
      classifier.train(category: :law, features: ["Australian politics", "indigenous affairs", "Domestic violence", "Government funding", "Q&A", "factcheck", "Family violence", "Funding cuts", "spending cuts", "Intimate partner violence"])
      # https://theconversation.com/coupon-justice-wont-address-legal-aid-crisis-19080
      classifier.train(category: :law, features: ["Justice", "IPA", "Legal aid", "Legal system"])
    end

    context "with a sport result input" do
      let(:result) { classifier.classify("Pharmaceuticals") }

      it "classifies a string as medical" do
        expect(result.category).to eq(:medical)
      end

      it "calculates correct scores" do
        expect(result.scores).to be_a(Hash)
        expect(result.scores.size).to eq(4)
        expect(result.scores[:maths].round(10)).to eq(BigDecimal.new("0.001934236"))
        expect(result.scores[:medical].round(10)).to eq(BigDecimal.new("0.0049586777"))
        expect(result.scores[:education].round(10)).to eq(BigDecimal.new("0.0027548209"))
        expect(result.scores[:law].round(10)).to eq(BigDecimal.new("0.0027548209"))
      end
    end
  end
  context "with a doc_id is re-trained" do
    let(:classifier) { Classifier::NaiveBayes.new(categories: [:ham, :spam]) }

    before do
      classifier.train(doc_id: "1", category: :spam, features: %w{Christmas Lunch})
      classifier.train(doc_id: "2", category: :ham, features: %w{Thanksgiving Lunch})
      classifier.train(doc_id: "3", category: :spam, features: %w{Viagra for Christmas})
      classifier.train(doc_id: "1", category: :ham, features: %w{Christmas Lunch})
    end

    context "with a ham input" do
      let(:result) { classifier.classify(%w{Birthday Lunch}) }

      it "classifies a string as sports" do
        expect(result.category).to eq(:ham)
      end

      it "calculates correct scores" do
        expect(result.scores).to be_a(Hash)
        expect(result.scores.size).to eq(2)
        expect(result.scores[:ham].round(10)).to eq(BigDecimal.new("0.024691358"))
        expect(result.scores[:spam].round(10)).to eq(BigDecimal.new("0.0052083333"))
      end
    end
  end
end
