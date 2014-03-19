def parser(string)
  input = string.split(' ')
  result_hash = {command: nil, patient: nil, doctor: nil, insurance: nil, birthdate: nil}
  command_hash = { %w(make create new add) => "add", %(remove delete del) => "del",
                   %w(list show display print) => "list"}

  doctors = DB.exec("SELECT * FROM doctor").map{ |entry| entry['name'] }
  patients = DB.exec("SELECT * FROM patient").map{ |entry| entry['name'] }

  input.each do |token|
    if doctors.include? token
      result_hash[:doctor] = token
      input.delete(token)
    elsif patients.include? token
      result_hash[:patient] = token
      input.delete(token)
    end
  end

  input.each do |token|
    command_hash.each do |key, value|
      if key.include?(token)
        result_hash[:command] = value
        input.delete(token)
      end
    end
  end

  regex = /('s)|(patient)|(of)|(doctor)|(a)|(Dr.)|(the)|(for)/

  input = input.join(" ").gsub(regex, '').split

  if result_hash[:patient] == nil
    result_hash[:patient] = input.join(" ")
  elsif result_hash[:doctor] == nil
    result_hash[:doctor] = input.join(" ")
  end

  return build_command(result_hash)
end

def build_command(result_hash)
  code_string = "#{result_hash[:command]}("

  result_hash.each do |key, value|
    if key != :command
      if value != nil
        code_string += '"' + value + '",'
      else
        code_string += "nil,"
      end
    end
  end

  code_string += ")"

  code_string
end

