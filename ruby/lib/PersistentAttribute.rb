require "Boolean"
class PersistentAttribute
  PRIMITIVE_VALUES = [String, Boolean, Numeric]
  VALIDATIONS = %w[no_blank from to validate]
  UnInitializedVariable = Class.new(StandardError)
  FromError = Class.new(StandardError)
  ToError = Class.new(StandardError)
  ValidateError = Class.new(StandardError)
  TypeError = Class.new(StandardError)
  UnknownValidationError = Class.new(StandardError)
  ValueIsNotAcceptableToPersist = Class.new(StandardError)

  attr_accessor :class_type, :attr_name, :optional_params
  
  def initialize(class_type, attribute, opt_params)
    @class_type = class_type
    @attr_name = attribute
    @optional_params = opt_params
  end

  def raise_validation_error(validation_name)
    case validation_name
    when "no_blank"
      raise UnInitializedVariable
    when "from"
      raise FromError
    when "to"
      raise ToError
    when "validate"
      raise ValidateError
    end
  end
  def exec_validation_condition(validation_name, attr_value, validation)
    case validation_name
    when "no_blank"
      return attr_value == "" || attr_value.nil?
    when "from"
      return attr_value < validation
    when "to"
      return attr_value > validation
    when "validate"
      return !validation.call(attr_value)
    end
  end
  def exec_validation(validation_name, attr_value)
    validation = optional_params[validation_name.to_sym]
    if validation
      if exec_validation_condition(validation_name, attr_value, validation)
        raise_validation_error(validation_name)
      end
    end
  end
  def exec_all_validations(attr_value)
    VALIDATIONS.each do |validation_name|
      exec_validation(validation_name, attr_value)
    end
  end

  def validate_content(one_instance)
    attr_value = one_instance.send(attr_name)
    exec_all_validations(attr_value)
  end

  def is_a_primitive_value(value)
    is_primitive_value = false
    PRIMITIVE_VALUES.each do |value_type|
      if value.is_a?(value_type)
        is_primitive_value = true
      end
    end
    is_primitive_value
  end

  def validate_primitive_value(value)
    unless value_is_persistent
      unless is_a_primitive_value(value)
        raise ValueIsNotAcceptableToPersist
      end
    end
  end

  def validate_types(one_instance)
    value = one_instance.send(attr_name)
    if value
      validate_primitive_value(value)
      unless value.is_a?(class_type)
          raise TypeError
      end
    end
    self.validate_content(one_instance)
  end

  def get_hash_attr_value(one_instance)
    hash = {}
    value = one_instance.send(attr_name)
    value = (value.nil? && attr_name.to_s != "id") ? valor_default: value
    if value.nil? && attr_name.to_s != "id"
      raise UnInitializedVariable
    end
    if !value.nil? && value_is_persistent && !value.is_a?(Array)
      if value.id.nil?
        value = value.save!
      else
        value = value.id
      end
    end
    if value.is_a?(Array) && value_is_persistent
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
  
  def valor_default
    valor = optional_params[:default]
    valor
  end

  def get_primitive_value_or_object_value(value, class_name)
    if value_is_persistent
      if value == 'intermediate_table'
        second_table_name = class_type.to_s.downcase
        table_name = "#{class_name}_#{second_table_name}"

        object_entries = find_by_intermediate_table_object_entries(table_name)
        value = object_entries.map do |object_entry|
          class_type.get_object_from_entry(object_entry)
        end
      else
        id = value
        object_entry = class_type.find_by_table_name_and_id(class_type.to_s.downcase, id)
        value = class_type.get_object_from_entry(object_entry)
      end
    end
    value
  end

  def find_by_intermediate_table_object_entries(class_name)
    table = TADB::DB.table(class_name)
    second_table_name = class_name.split("_").last
    id_attr = "id_"+second_table_name
    table.entries.map do |id_entry|
      class_type.find_by_table_name_and_id(second_table_name, id_entry[id_attr.to_sym])
    end
  end
  
end