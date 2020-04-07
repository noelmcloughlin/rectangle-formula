# frozen_string_literal: true

control 'rectangle package' do
  title 'should be installed'

  describe file('/Applications/Rectangle') do
    it { should exist }
  end
end
