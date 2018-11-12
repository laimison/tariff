RSpec.describe Tariff do
  it "has a version number" do
    expect(Tariff::VERSION).not_to be nil
  end
  
  it 'true reports true' do
    expect(true).to be true
  end
end
