require 'classifier/naive_bayes'
require 'pp'

RSpec.describe Classifier::NaiveBayes do

  context "with monkey learn data" do
    let(:classifier) { Classifier::NaiveBayes.new(categories: [:sports, :not_sports]) }

    before do
      classifier.train(:sports, %w{A great game})
      classifier.train(:not_sports, %w{The election was over})
      classifier.train(:sports, %w{Very clean match})
      classifier.train(:sports, %w{A clean but forgettable game})
      classifier.train(:not_sports, %w{It was a close election})
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
      classifier.train(:maths, ["Mathematics", "Education", "Schools", "Teaching", "Math anxiety", "Teaching maths", "academic performance", "Better Teachers"])
      # https://theconversation.com/eleven-games-and-activities-for-parents-to-encourage-maths-in-early-learning-76522
      classifier.train(:maths, ["Mathematics", "Learnin", "Early childhood education", "Parents", "Early childhood learning", "Parents role in education"])
      # https://theconversation.com/the-goldwater-rule-prevents-psychiatrists-diagnosing-trump-from-afar-but-some-say-theres-too-much-at-stake-81674
      classifier.train(:medical, ["Psychology", "Psychiatry", "US politics", "Sigmund Freud", "Psychotherapy", "attention deficit hyperactivity disorder", "Narcissism", "Donald Trump", "Diagnosis", "Barry Goldwater", "Psychoanalysis"])
      # https://theconversation.com/greg-hunts-plan-to-reduce-hospital-admissions-wont-work-if-he-cant-measure-successes-and-failures-81834
      classifier.train(:medical, ["COAG", "Health funding", "hospital funding", "Greg Hunt", "Health data", "health care policy"])
      # https://theconversation.com/weekly-dose-methylprednisolone-a-drug-for-treating-inflammation-but-not-rare-kidney-disease-81893
      classifier.train(:medical, ["Research", "Kidney disease", "Pharmaceuticals", "Arthritis", "Pharmacology", "Medication", "Asthma", "Side effects", "Corticosteroid", "Allergy", "Psoriasis", "Corticosteroids", "Weekly Dose"])
      # https://theconversation.com/to-empower-students-with-effective-writing-skills-handwriting-matters-81949
      classifier.train(:education, ["Children", "Teaching", "Primary education", "Secondary education", "NAPLAN", "Writing", "Primary school", "Handwriting", "Classrooms"])
      # https://theconversation.com/universities-have-a-problem-with-sexual-assault-and-harassment-heres-how-to-fix-it-81096
      classifier.train(:education, ["Relationships", "Violence", "Sexual harassment", "Australian universities", "Campus sexual assault"])
      # https://theconversation.com/artificial-intelligence-holds-great-potential-for-both-students-and-teachers-but-only-if-used-wisely-81024
      classifier.train(:education, ["Artificial intelligence", "Intelligence Technology", "Big data", "data", "Learning analytics"])
      # https://theconversation.com/explainer-what-is-fair-dealing-and-when-can-you-copy-without-permission-80745
      classifier.train(:law, ["Law", "Copyright", "Digital copyright", "Fair use", "Technology explainer"])
      # https://theconversation.com/factcheck-qanda-what-are-the-facts-on-funding-for-domestic-violence-legal-services-in-australia-69214
      classifier.train(:law, ["Australian politics", "indigenous affairs", "Domestic violence", "Government funding", "Q&A", "factcheck", "Family violence", "Funding cuts", "spending cuts", "Intimate partner violence"])
      # https://theconversation.com/coupon-justice-wont-address-legal-aid-crisis-19080
      classifier.train(:law, ["Justice", "IPA", "Legal aid", "Legal system"])
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
end
