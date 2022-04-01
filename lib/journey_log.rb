class JourneyLog
  attr_reader  

  def initialize
    @history = []
    @current_journey = nil
  end

  def start(station)
    @current_journey = Journey.new(station)
  end

  def finish(station)
    @current_journey.end_journey(station)
    record_journey(@current_journey)
    @current_journey = nil
  end 

  def current_journey
    if @current_journey == nil
      start(:unknown)
    else
      @current_journey
    end
  end

  def on_going_journey?
    @current_journey != nil
  end

  def journeys
    @history.dup
  end

  private
  def record_journey(journey)
    @history << {entry_station: journey.entry_station , exit_station: journey.exit_station, fare: journey.fare }
  end

end