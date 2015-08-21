require 'spec_helper'
describe 'midonet_mem' do

  context 'with defaults for all parameters' do
    it { should contain_class('::midonet_mem') }
  end
end
