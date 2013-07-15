module Shipping
  class TrackingResponse

    attr_reader :tracking_number # string
    attr_reader :shipment_events # array of ShipmentEvents in chronological order
    attr_reader :origin, :destination

    def initialize(options = {})
      @tracking_number = options[:tracking_number]
      @shipment_events = Array(options[:shipment_events])
      @origin, @destination = options[:origin], options[:destination]
    end

    def latest_event
      @shipment_events.first
    end

  end
end
