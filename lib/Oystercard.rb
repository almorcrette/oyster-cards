require_relative './journey'
require_relative './station'
require_relative './journey_log'

class Oystercard
  attr_reader :balance, :limit, :journeys, :current_journey, :journey_log

  LIMIT = 90.0
  MIN_BALANCE = 1.0 # will become redundant
  
  def initialize(journey_log = JourneyLog.new)
    @balance = 0.0
    @limit = LIMIT
    @journeys = []
    @journey_log = journey_log
  end

  def top_up(amount)
    raise "Top-up will exceed limit of £#{@limit}" if exceed_limit?(amount)
    @balance += amount.to_f
    "Your balance is £#{@balance}"
  end

  def in_journey?
    @journey_log.on_going_journey?
  end

  def touch_in(station)
    if @journey_log.on_going_journey?
      force_touch_out
    end
    fail "Insufficient balance" if insufficient_balance?
    journey = @journey_log.start(station)
  end

  def touch_out(station)
    if @journey_log.on_going_journey? == false
      force_touch_in(:unknown)
    end
    @journey_log.finish(station)
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
    @journey_log.finish(:unknown)
    deduct(@journey_log.journeys.last[:fare])
  end

  def force_touch_in(station)
    @journey_log.start(:unknown)
  end

  def finish_journey(station)
    @journey_log.finish(station)
    deduct(@journey_log.journeys.last[:fare])
  end

end
