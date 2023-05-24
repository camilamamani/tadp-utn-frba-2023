class PersistentAttribute
  TypeError = Class.new(StandardError)
  attr_accessor :class_type, :attr_name, :content_validations
  def initialize(class_type, attribute)
    @class_type = class_type
    @attr_name = attribute
  end

  def setContentValidations(**validations)
    @content_validations = *validations
  end
  def validate_content(one_instance)
    attr_value = one_instance.send(attr_name)
    unless content_validations.nil?
      content_validations.each do |param, value|
        puts "param: #{param}, value: #{value}"
        case param.to_s
        when "no_blank"
          if value
            if attr_value == "" || attr_value.nil?
              raise TypeError
            end
          end
        when "from"
          puts "It's a banana!"
        when "to"
          puts "It's an orange!"
        when "validate"
          puts("algo")
        else
          puts "nada"
        end
      end
    end
  end

  def validate(one_instance)
    value = one_instance.send(attr_name)
    if attr_name.to_s != "id" && !value.nil?
      value_type =  value.class.to_s
      if  value_type != class_type.to_s
        unless value_type == "TrueClass"|| value_type == "FalseClass"
          raise TypeError
        end
      end
    end
    self.validate_content(one_instance)
  end


  def get_hash_attr_value(one_instance)
    hash = {}
    value = one_instance.send(attr_name)
    value = (value.nil? && attr_name.to_s != "id") ? "..." : value
    if !value.nil? && value_is_persistent && !value.is_a?(Array)
      if value.id.nil?
        value = value.save!
      else
        value = value.id
      end
    end
    if value.is_a?(Array)
      value = 'intermediate_table'
    end
    hash[attr_name] = value
    hash
  end

  def save_array(object_list, table_id, table_name)
  end
  def value_is_persistent
    self.class_type.respond_to?(:has_one)
  end
end