class PersistentAttributeMany < PersistentAttribute
  def initialize(class_type, attribute, opt_params)
    super(class_type, attribute, opt_params)
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
        unless  value.is_a?(class_type)
            raise TypeError
        end
      end
    end
    self.validate_content(one_instance)
  end

  def exec_validation_condition(validation_name, attr_value_list, validation)
    case validation_name
    when "no_blank"
      return attr_value_list.all? { |attr_value| attr_value == "" || attr_value.nil? }
    when "from"
      return attr_value_list.all? { |attr_value| attr_value < validation }
    when "to"
      return attr_value_list.all? { |attr_value| attr_value > validation }
    when "validate"
      return attr_value_list.all? { |attr_value| !validation.call(attr_value) }
    end
  end
  
  def valor_default
    valor = optional_params[:default]
    valor ? valor : []
  end
end