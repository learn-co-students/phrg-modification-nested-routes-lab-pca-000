require 'spec_helper'

describe 'rubocop analysis' do
  it 'has no offenses' do
    expect(`rubocop`).to match(/no\ offenses\ detected/)
  end
end
