require 'rspec'
require 'doctor'
require 'patient'

describe 'Doctor' do
  it 'sets up a doctor object' do
    doc = Doctor.new
    doc.should be_an_instance_of Doctor
  end
end
