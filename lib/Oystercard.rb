require_relative './journey'
require_relative './station'

class Oystercard
  attr_reader :balance, :limit, :journeys, :current_journey

  LIMIT = 90.0
  MIN_BALANCE = 1.0 # will become redundant
  
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
      force_touch_out
    end
    fail "Insufficient balance" if insufficient_balance?
    journey = Journey.new(station)
    @current_journey = journey
  end

  def touch_out(station)
    if @current_journey == nil
      force_touch_in
    else
      finish_journey
    end
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
    @balance < MIN_BALANCE
  end

  def force_touch_out
    @current_journey.end_journey(:unknown)
    journeys.push(@current_journey)
    deduct(@current_journey.fare)
  end

  def force_touch_in
    @current_journey = Journey.new(:unknown)
    finish_journey
  end

  def finish_journey
    @current_journey.end_journey(station)
    deduct(@current_journey.fare)
  end

end
