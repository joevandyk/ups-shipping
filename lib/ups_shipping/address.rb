require "nokogiri"

module Shipping
  class Address
    ADDRESS_TYPES = %w{residential commercial po_box}
    attr_accessor :address_line1, :address_line2, :address_line3, :city, :state, :zip, :country, :type

    def initialize(options={})
      @address_line1 = options[:address_line1]
      @address_line2 = options[:address_line2]
      @address_line3 = options[:address_line3]
      @city = options[:city]
      @state = options[:state]
      @zip = options[:zip]
      @country = options[:country]
      @type = options[:type]
    end

    def build(xml)
      xml.Address {
        xml.AddressLine1 @address_line1
        xml.AddressLine2 @address_line2
        xml.AddressLine3 @address_line3
        xml.City @city
        xml.StateProvinceCode @state
        xml.PostalCode @zip
        xml.CountryCode @country
      }
    end

    def to_xml()
      builder = Nokogiri::XML::Builder.new do |xml|
        build(xml)
      end
      builder.to_xml
    end
  end
end