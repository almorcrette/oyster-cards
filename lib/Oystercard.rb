require_relative './journey'
require_relative './station'

class Oystercard
  attr_reader :balance, :limit, :journeys, :current_journey

  LIMIT = 90.0
  MINIMUM = 1.0
  PENALTY_FARE = 6.0
  
  def initialize
    @balance = 0.0
    @limit = LIMIT
    @journeys = []
    @current_journey = nil
  end

  def top_up(amount)
    raise "Top-up will exceed limit of £#{@limit}" if exceed_limit?(amount)
    @balance += amount.to_f
    "Your balance is £#{@balance}"
  end

  def in_journey?
    @current_journey != nil
  end

  def touch_in(station)
    if @current_journey !=nil
      @current_journey.end_journey(:unknown)
      journeys.push(@current_journey)
      deduct(PENALTY_FARE)
    end
    fail "Insufficient balance" if insufficient_balance?
    journey = Journey.new(station)
    @current_journey = journey
  end

  def touch_out(station)
    if @current_journey == nil
      @current_journey = Journey.new(:unknown)
      deduct(PENALTY_FARE)
    else
      deduct(MINIMUM)
    end
    @current_journey.end_journey(station)
    journeys.push(@current_journey)
    @current_journey = nil
  end

private

  def deduct(amount)
    @balance -= amount
    "Your balance is now £#{@balance}"
  end

  def exceed_limit?(amount)
    @balance + amount > @limit
  end

  def insufficient_balance?
    @balance < MINIMUM
  end
end
