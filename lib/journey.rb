class Journey
  attr_reader :entry_station, :exit_station

  MINIMUM = 1.0
  PENALTY_FARE = 6.0

  def initialize(entry_station)
    @entry_station = entry_station
    @exit_station = nil
  end

  def complete?
    @exit_station != nil
  end

  def end_journey(exit_station)
    @exit_station = exit_station
  end

  def fare
    if @entry_station == :unknown || @exit_station == :unknown # Not SRP. Refactor this with private method #is_penalty_journey?
      PENALTY_FARE
    else
      MINIMUM
    end
  end
end
