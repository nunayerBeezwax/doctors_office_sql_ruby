require 'rspec'
require 'doctor'
require 'patient'
require 'pg'

DB = PG.connect(:dbname => 'doctors_office_test')
RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM doctor *;")
    DB.exec("DELETE FROM patient *;")
  end
end

describe 'Doctor' do
  it 'sets up a doctor object' do
    doc = Doctor.new({})
    doc.should be_an_instance_of Doctor
  end

  it 'initializes with name and specialty set' do
    doc = Doctor.new({:name => "Gregory House", :speciality => "sarcasm"})
    doc.name.should eq "Gregory House"
    doc.speciality.should eq "sarcasm"
  end

  describe '#save' do
    it "saves current object info to database" do
      doc = Doctor.new({:name => "Gregory House", :speciality => "sarcasm"})
      doc.save
      Doctor.all.should eq [doc]
    end
  end
end

describe 'Patient' do
  it 'initializes a patient object with name and birthdate' do
    patient = Patient.new({:name => "Robinson Crusoe", :birthdate => "January 1, 1969"})
    patient.should be_an_instance_of Patient
    patient.name.should eq "Robinson Crusoe"
    patient.birthdate.should eq "January 1, 1969"
  end

  describe '#save' do
    it "saves current object info to database" do
      patient = Patient.new({:name => "Patient 0", :birthdate => "1969-01-17"})
      patient.save
      Patient.all.should eq [patient]
    end
  end
end
