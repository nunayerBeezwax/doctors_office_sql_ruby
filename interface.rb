require "./lib/doctor"
require "./lib/patient"
require "./lib/input_parser"
require "pg"

def help
  puts "Type 'add doctor' to add a new doctor"
  puts "     'add patient' to add a new patient"
  puts "     'list doctors' to see all the physicians"
  puts "     'delete doctor' to remove a doctor"
  puts "     'delete patient' to remove a patient"
  puts "     'list patients' to see all current patients"
  puts "     'list all' to see a chart of doctors and patients"
  puts "     'specialities' to see doctors by speciality"
  puts "     'quit' to exit the program\n\n"
end

def main_menu
  print "> "
  input = parser(gets.chomp)

  print input
  eval input
  # case input
  # when "q" || "quit"
  #   exit
  # when "add doctor"
  #   add_doctor
  # when "add patient"
  #   add_patient
  # when "list doctors"
  #   list_doctors
  # when "list patients"
  #   list_patients
  # when "specialities"
  #   list_doctors_by_speciality
  # when "delete doctor"
  #   delete_doctor
  # when "delete patient"
  #   delete_patient
  # end
end

def add(patient, doctor, insurance, birthdate)
  doctor_id = DB.exec("SELECT id FROM doctor WHERE name LIKE '%#{doctor}%';")[0]['id']
  DB.exec("INSERT INTO patient (name, doctor_id) VALUES ('#{patient}', #{doctor_id});")
end

# def add_doctor
#   print "What is the name of the doctor? "
#   name = gets.chomp

#   print "What is their speciality? "
#   speciality = gets.chomp

#   print "What insurance do they accept?"
#   insurance = gets.chomp
#   insurance_id = DB.exec("SELECT id FROM insurance
#                          WHERE name LIKE '%#{insurance}%';")[0]["id"]

#   Doctor.new({name: name, speciality: speciality,
#               insurance_id: insurance_id}).save
# end

# def add_patient
#   print "What is the patient's name? "
#   name = gets.chomp

#   print "When was #{name} born? "
#   birthdate = gets.chomp

#   print "What is the name of their doctor? "
#   doctor = gets.chomp
#   doctor_id = DB.exec("SELECT id FROM doctor
#                        WHERE name LIKE '%#{doctor}%';")[0]["id"]

#   print "What is their insurance?"
#   insurance = gets.chomp
#   insurance_id = DB.exec("SELECT id FROM insurance
#                           WHERE name LIKE '%#{insurance}%';")[0]["id"]

#   Patient.new({name: name, birthdate: birthdate, doctor_id: doctor_id,
#                insurance_id: insurance_id}).save
# end

def list()

end

def list_doctors
  doctors = DB.exec("SELECT * FROM doctor")
  doctors.each { |result| puts result['name'] }
end

def list_patients
  patients = DB.exec("SELECT * FROM patient")
  patients.each { |result| puts result['name'] }
end

def list_all
  doctors = DB.exec("SELECT * FROM doctor")
  doctors.each do |result|
    puts result['name']
    patient_num = DB.exec("SELECT COUNT(*) FROM patient WHERE doctor_id = #{result['id']};")
    puts "  Total patients: #{patient_num[0]["count"]}"
    DB.exec("SELECT * FROM patient WHERE doctor_id = #{result['id']};").each do |patient|
      puts "      #{patient['name']}"
    end
    print "\n------------\n\n"
  end
end

def list_doctors_by_speciality
  print "Enter a speciality to see all the doctors who practice it: "
  input = gets.chomp
  doctors = DB.exec("SELECT * FROM doctor WHERE speciality LIKE '#{input}'")
  puts "\e[1m#{input}: \e[0m"
  doctors.each { |result| puts result['name'] }
end

def delete_doctor
  print "Enter the name of the doctor you would like to delete: "
  input = gets.chomp

  DB.exec("DELETE FROM doctor WHERE name LIKE '#{input}';")
end

def delete_patient
  print "Enter the name of the patient you would like to delete: "
  input = gets.chomp

  DB.exec("DELETE FROM patient WHERE name LIKE '#{input}';")
end



DB = PG.connect({:dbname => "doctors_office"})

system 'clear'

puts "Welcome to the Flatbush Hospital Database!"
puts "-------------------------"
help

loop do
  main_menu
end
