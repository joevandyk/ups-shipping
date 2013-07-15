#ups-shipping

UPS Shipping gem

## Examples

```ruby
# Initialize a new UPS instance
ups = Shipping::UPS.new("login", "password", "license", :test => false)

# Create an address
address = Shipping::Address.new(
  :address_line1 => "1402 Faber St."
  :address_line2 => "APT 2B"
  :city => "Durham",
  :state => "NC",
  :zip => "27705",
  :country => "US"
)

# Validate that address
ups.validate_address(address)

# Create an organization with that address
organization = Shipping::Organization.new(
  :name => "Transcriptic",
  :phone => "1233455678",
  :address => @address
)

# Track a Shipment
tracking_result = ups.track_shipment("1ZXX31290231000092")
