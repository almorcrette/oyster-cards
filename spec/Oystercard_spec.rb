require_relative '../lib/Oystercard.rb'
require_relative '../lib/journey.rb'

describe Oystercard do
  let (:station) { double (:station) }
  let (:station2) { double (:station) }
  let (:journey) { double (:journey) }

  it "has a balance when created" do
    expect(subject.balance).to eq 0.0
  end

  it "current journey is nil when created" do
    expect(subject.current_journey).to eq nil
  end

  it "doesn't have any saved journeys when created" do
    expect(subject.journeys).to eq []
  end

  it "can update the balance topped up" do
    expect(subject.top_up(5)).to eq "Your balance is £5.0"
  end

  it "has a maximum balance of £90" do
    subject.top_up(subject.limit)
    expect {subject.top_up(1) }.to raise_error("Top-up will exceed limit of £#{subject.limit}")
  end

  it {is_expected.to respond_to(:in_journey?)}

  it "will not touch in if balance is below the minimum fare" do
    expect { subject.touch_in(:station) }.to raise_error("Insufficient balance")
  end

  it "creates a new journey when touching in" do
    subject.top_up(5)
    expect(subject.touch_in(station)).to be_an_instance_of(Journey)
    #expect { subject.touch_in(:station) }.to change{ subject.entry_station }.to(:station)
  end

  context "with positive balance and touched in" do 
    before (:each) do
      subject.top_up(5)
      subject.touch_in(station)
    end

    it "is 'in journey'" do
      allow(journey).to receive(:complete?).and_return(false)
      expect(subject.in_journey?).to be true
    end

    it "is not 'in journey' if it has been touched out" do
      allow(journey).to receive(:complete?).and_return(true)
      subject.touch_out(station2)
      expect(subject.in_journey?).to be false
    end
  end

  context "when touching out at the end of a journey" do
    before (:each) do
      subject.top_up(5)
      subject.touch_in(station)
    end

    it "will deduct the minimum fare" do
      expect { subject.touch_out(station2) }.to change{ subject.balance }.by(-1)
    end

    it "logs the entire journey" do
      subject.touch_out(station2)
      expect(subject.journeys[-1]).to be_an_instance_of(Journey)
    end
  end

  context "penalty fares" do

    context "if touched out without touching in" do 
      it 'deducts the penalty fare from balance' do
        expect { subject.touch_out(station2) }.to change { subject.balance }.by(-6.0)
      end

      it "logs the penalty journey" do
        subject.touch_out(station2)
        expect(subject.journeys[-1]).to be_an_instance_of(Journey) # Isn't testing whether the journey has unknown entry station
      end
    
    end

    context "if touched in again, without touching out first" do

      before(:each) do
        subject.top_up(10)
        subject.touch_in(station)
      end

      it 'deducts the penalty far from balance' do
        expect { subject.touch_in(station2) }.to change { subject.balance }.by(-6.0)
      end

      it 'logs the penalty journey' do
        subject.touch_in(station2)
        expect(subject.journeys[-1]).to be_an_instance_of(Journey) # Isn't testing whether the journey has unknown exit station
      end
    end
  end
end