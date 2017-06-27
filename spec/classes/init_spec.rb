require 'spec_helper'
describe 'factorio' do

  context 'with defaults for all parameters' do
    it { should contain_class('factorio') }
  end
end
