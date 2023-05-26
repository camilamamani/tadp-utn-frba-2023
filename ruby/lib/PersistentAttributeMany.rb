class PersistentAttributeMany < PersistentAttribute
  def initialize(class_type, attribute, **validations)
    super(class_type, attribute, **validations)
  end
  def save_array(object_list, table_id, table_name)
    second_table_name = object_list[0].class.name.downcase
    intermediate_table_name = "#{table_name}_#{second_table_name}"
    object_list.each do |object|
      id = object.save!
      hash = {"id_#{table_name}": table_id, "id_#{second_table_name}": id}
      TADB::DB.table(intermediate_table_name).insert(hash)
    end
  end
  def validate_types(one_instance)
    values = one_instance.send(attr_name)
    if !values.nil?
      values.each do |value|
        value_type =  value.class.to_s
        if  value_type != class_type.to_s
            raise TypeError
        end
      end
    end
    self.validate_content(one_instance)
  end

  def validate_content(one_instance)
    attr_values = one_instance.send(attr_name)
    unless content_validations.nil?
      content_validations.each do |param, value|
        case param.to_s
        when "validate"
          attr_values.each do |attr_value|
            unless value.call(attr_value)
              raise ValidateError
            end
          end
        else
          raise UnknownValidationError
        end
      end
    end
  end


end