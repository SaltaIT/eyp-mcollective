require 'spec_helper'
describe 'mcollective' do

  context 'with defaults for all parameters' do
    it { should contain_class('mcollective') }
  end
end
