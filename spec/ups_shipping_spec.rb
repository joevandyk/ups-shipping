require "rspec"
require "ups_shipping"

describe Shipping::UPS do
  before(:all) do
    SPEC_ROOT = File.dirname(__FILE__).freeze
    ups_credentials_path = "#{SPEC_ROOT}/config/ups_credentials.yml"

    if !File.exists?(ups_credentials_path)
      raise "You need to add your own UPS test credentials in spec/config/ups_credentials.yml. See spec/config/ups_credentials.example.yml for an example."
    end

    ups_credentials = YAML.load(File.read(ups_credentials_path))

    @ups = Shipping::UPS.new(ups_credentials["account"], ups_credentials["password"], ups_credentials["key"], :test => false)

    @address = Shipping::Address.new(
        :address_line1 => "1402 Faber St.",
        :address_line2 => "APT 2B",
        :city => "Durham",
        :state => "NC",
        :zip => "27705",
        :country => "US"
    )
  end

  it "address object" do
    @address.to_xml.gsub(/^\s+/, "").gsub(/\s+$/, $/).should == '
      <?xml version="1.0"?>
      <Address>
        <AddressLine1>1402 Faber St.</AddressLine1>
        <AddressLine2>APT 2B</AddressLine2>
        <AddressLine3></AddressLine3>
        <City>Durham</City>
        <StateProvinceCode>NC</StateProvinceCode>
        <PostalCode>27705</PostalCode>
        <CountryCode>US</CountryCode>
      </Address>
      '.gsub(/^\s+/, "").gsub(/\s+$/, $/)
  end

  it "organization object" do
    @organization = Shipping::Organization.new(
        :name => "Transcriptic",
        :phone => "1233455678",
        :address => @address
    )
    puts @organization.to_xml("Shipper")
  end

  it "validates address" do
    @validate_address = @ups.validate_address(@address)
    @validate_address["AddressValidationResponse"]["Response"]["ResponseStatusCode"].should == "1"
    puts @validate_address
  end

  it "track shipment" do
    @tracking_result = @ups.track_shipment("1ZYA52510353561107")
    @tracking_result.should have_key("TrackResponse")
    @tracking_result["TrackResponse"]["Response"]["ResponseStatusCode"].should == "1"
    puts @tracking_result
  end

  it "parse tracking response" do
    @tracking_result = @ups.track_shipment("1ZYA52510353561107")
    @parsed_tracking = @ups.parse_tracking_response(@tracking_result)
    @parsed_tracking.tracking_number.should == "1ZYA52510353561107"
    puts @parsed_tracking.latest_event
    puts @parsed_tracking.origin
  end

end