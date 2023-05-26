class PersistentAttribute
  TypeError = Class.new(StandardError)
  FromError = Class.new(StandardError)
  ToError = Class.new(StandardError)
  ValidateError = Class.new(StandardError)
  UnknownValidationError = Class.new(StandardError)
  UnInitializedVariable = Class.new(StandardError)
  
  attr_accessor :class_type, :attr_name, :optional_params
  
  def initialize(class_type, attribute, opt_params)
    @class_type = class_type
    @attr_name = attribute
    @optional_params = opt_params
  end

  def validate_no_blank(attr_value)
    no_blank = optional_params[:no_blank]
    if no_blank && class_type == String
      if attr_value == "" || attr_value.nil?
        raise TypeError
      end
    end
  end
  
  def validate_from_to(attr_value)
    from = optional_params[:from]
    to = optional_params[:to]
    if from
      if attr_value < from
        raise FromError
      end
    end
    if to
      if attr_value > to
        raise ToError
      end
    end
  end

  def validate_validate(attr_value)
    validation = optional_params[:validate]
    if validation
      unless validation.call(attr_value)
        raise ValidateError
      end
    end
  end
  
  def validate_content(one_instance)
    attr_value = one_instance.send(attr_name)
    validate_no_blank(attr_value)
    validate_from_to(attr_value)
    validate_validate(attr_value)
  end

  def validate_types(one_instance)
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
  
  def valor_default
    valor = optional_params[:default]
    valor
  end
end