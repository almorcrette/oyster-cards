require_relative '../lib/journey'

describe Journey do
  let(:journey) { Journey.new(:station0) }
  let(:station1) { double (:Station) }
  let(:station2) { double (:Station) }
  
  it "has an entry station when created" do
    expect(journey.entry_station).to eq :station0
  end

  it "sets exit station as nil when created" do
    expect(journey.exit_station).to eq nil
  end

  it "sets 'complete' to false when created" do
    expect(journey.complete?).to be false
  end

  context "#end_journey" do
    it "updates the exit station to the argument that is passed" do
      expect { journey.end_journey(station1) }.to change{ journey.exit_station }.to(station1)
    end
  end

  context '#fare' do

    it "returns £1 unless it's a penalty journey" do
      expect(journey.fare).to eq Journey::MINIMUM
    end

    it "returns £6 if there is no touch_out" do
      journey2 = Journey.new(station1)
      journey2.end_journey(:unknown)
      expect(journey2.fare).to eq Journey::PENALTY_FARE #Read this Coral. We'd written expect(journey.fare)...
    end

    it "returns £6 if there is no touch_in" do
      journey2 = Journey.new(:unknown)
      journey2.end_journey(station1)
      expect(journey2.fare).to eq Journey::PENALTY_FARE
    end  
  end
end

