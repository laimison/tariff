require 'tariff2'

RSpec.describe Tariff2 do
  it "has a version number" do
    expect(Tariff2::VERSION).not_to be nil
  end
  
  it 'true reports true' do
    expect(true).to be true
  end
end
