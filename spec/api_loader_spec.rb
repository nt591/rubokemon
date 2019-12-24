require 'api_loader'
require 'webmock/rspec'
require 'json'

RSpec.describe API::Loader do
  it 'errors on an invalid resource' do
    expect { API::Loader.new("fail") }.to raise_error(API::UnsupportedResourceError)
  end

  it 'raises an error for an invalid resource name' do
    api_loader = API::Loader.new("pokemon")
    stub_request(:get, "https://pokeapi.co/api/v2/pokemon/failure")
      .to_return(status: 404)

    expect { api_loader.get('failure')}.to raise_error(API::UnsupportedResourceError)
  end

  it 'returns a valid json object for an valid resource name' do
    api_loader = API::Loader.new("pokemon")
    expected = {"name" => "Chramander"}
    stub_request(:get, "https://pokeapi.co/api/v2/pokemon/charmander")
      .to_return(status: 200, body: expected.to_json)

    expect(api_loader.get('charmander')).to eq(expected)
  end
end