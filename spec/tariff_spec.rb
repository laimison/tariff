require 'tariff'

RSpec.describe Tariff do
  it "has a version number" do
    expect(Tariff::VERSION).not_to be nil
  end
  
  # More unit tests can be added before releasing ...
end
