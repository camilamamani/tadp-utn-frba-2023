require "tadb"

module Persistence

  def has_one(class_type, hash_name)
    puts "Entiendo has_one!!"
    puts class_type
    hash_name.each do |key, value|
      puts "#{key}: #{value}"
    end
  end

end