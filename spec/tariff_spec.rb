require 'tariff'

RSpec.describe Tariff do
  it 'has a version number' do
    expect(Tariff::VERSION).not_to be nil
  end

  it 'checks if any tariffs found in json' do
    my_tariff = Tariff.new
    expect(my_tariff.tariff_comparison(['cost', 1000, 100]).size).to_not be_zero
  end

  # It needs additional json for testing, otherwise test will be afected after json change
  # Various inputs and output can be tested using similar tests as above
end
