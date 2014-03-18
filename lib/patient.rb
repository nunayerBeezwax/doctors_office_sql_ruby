class Patient
  attr_reader :name, :birthdate, :doctor_id, :insurance_id

  def initialize(info_hash)
    @name = info_hash[:name]
    @birthdate = info_hash[:birthdate]
    @doctor_id = info_hash[:doctor_id]
    @insurance_id = info_hash[:insurance_id]
  end

  def save
    DB.exec("INSERT INTO patient (name, birthdate, doctor_id, insurance_id)
            VALUES ('#{name}', '#{birthdate}', '#{doctor_id}', #{insurance_id});")
  end

  def self.all
    results = DB.exec("SELECT * FROM patient")
    patients = []
    results.each do |result|
      name = result["name"]
      birthdate = result["birthdate"]
      doctor_id = result["doctor_id"]
      insurance_id = result["insurance_id"]
      patients << Patient.new({name: name, birthdate: birthdate, doctor_id: doctor_id, insurance_id: insurance_id})
    end
    patients
  end

  def ==(patient)
    patient.name == self.name && patient.birthdate == self.birthdate
  end
end
