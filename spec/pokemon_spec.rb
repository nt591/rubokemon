require 'pokemon'

RSpec.describe Pokemon do
  before(:each) do
    @pokemon = Pokemon.new("Charmander")
  end

  it "has a name" do
    expect(@pokemon.name).to eq("Charmander")
  end

  describe "class methods" do
    it "has a factory that takes a name a returns a pokemon" do
      expect(Pokemon.for "Charmander").to be_a(Pokemon)
    end
  end
end
