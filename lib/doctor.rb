class Doctor
  attr_reader :name, :speciality, :insurance_id

  def initialize(info_hash)
    @name = info_hash[:name]
    @speciality = info_hash[:speciality]
    @insurance_id = info_hash[:insurance_id]
  end

  def self.all
    results = DB.exec("SELECT * FROM doctor")
    doctors = []
    results.each do |result|
      name = result['name']
      speciality = result['speciality']
      insurance_id = result['insurance_id']
      doctors << Doctor.new({name: name, speciality: speciality, insurance_id: insurance_id})
    end
    doctors
  end

  def save
    DB.exec("INSERT INTO doctor (name, speciality, insurance_id) VALUES ('#{@name}', '#{@speciality}', #{@insurance_id});")
  end

  def ==(something)
    something.name == self.name && something.speciality == self.speciality
  end
end
