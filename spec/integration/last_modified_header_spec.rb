require 'http'

RSpec.describe 'Last-Modified Header' do
  include Spec::Support::IodineServer

  around(:example) do |ex|
    with_app(:last_modified) { ex.run }
  end

  it 'is parseable by Time#httpdate' do
    response = HTTP.get("http://localhost:2222")
    last_modified_str = response.headers['Last-Modified']
    parsed = Time.httpdate(last_modified_str)

    expect(parsed).to be_a(Time)
  end

  it 'does not override the header if it is explicitly set' do
    response = HTTP.get("http://localhost:2222?last_modified=foo")
    last_modified_str = response.headers['Last-Modified']

    expect(last_modified_str).to eql("foo")
  end

  it 'overrides the header if the value is set to nil' do
    response = HTTP.get("http://localhost:2222?last_modified=nil")
    last_modified_str = response.headers['Last-Modified']

    expect(Time.httpdate(last_modified_str)).to be_a(Time)
  end
end
