require 'journey_log'

describe JourneyLog do
  let(:journey_double) { double "journey" }
  let(:journey_log) { JourneyLog.new }
  let(:entry_station_double) { double "entry_station" } 
  let(:exit_station_double) { double "exit_station" } 
  let(:unknown_station_double) { double :unknown }
  let(:entry_to_exit) { {entry_station: entry_station_double, exit_station: exit_station_double, fare: 1.0} }
  
  it 'initiates with a empty history' do
    expect(journey_log.journeys).to eq []
  end 

  describe '#start' do
    it 'should start a journey' do
      journey_log.start(entry_station_double)
      allow(journey_log.current_journey).to receive(:entry_station).and_return(entry_station_double)
      expect(journey_log.current_journey.entry_station).to eq(entry_station_double)
    end
  end

  describe '#finish' do
    it 'adds the completed journey to the history' do
      journey_log.start(entry_station_double)
      allow(journey_log.current_journey).to receive(:entry_station).and_return(entry_station_double)
      journey_log.finish(exit_station_double)
      allow(journey_log.current_journey).to receive(:exit_station).and_return(exit_station_double)
      expect(journey_log.journeys.last).to eq(entry_to_exit)
    end
  end

  describe '#journeys' do
    it 'list all previous journeys' do
      journey_log.start(entry_station_double)
      journey_log.finish(exit_station_double)
      expect(journey_log.journeys).to eq([entry_to_exit])
    end
  end

  describe '#current_journey' do
    it 'return incomplete journey' do
      journey_log.start(entry_station_double)
      expect(journey_log.current_journey.entry_station).to eq(entry_station_double)
    end

    it 'if no journey, create a new journey' do
      journey_log.current_journey
      expect(journey_log.current_journey.entry_station).to eq(:unknown)
    end
  end
end