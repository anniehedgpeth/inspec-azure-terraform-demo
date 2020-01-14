control 'vm config' do
  describe user('tkuser') do
    its('home') { should eq '/home/tkuser' }
  end

  describe directory('/home/tkuser') do
    it { should exist }
    its('owner') { should eq 'tkuser' }
  end
end