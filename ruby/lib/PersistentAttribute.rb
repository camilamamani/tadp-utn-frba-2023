class PersistentAttribute
  TypeError = Class.new(StandardError)
  attr_accessor :class_type, :attr_name
  def initialize(class_type, attribute)
    @class_type = class_type
    @attr_name = attribute
  end
  def validate(one_instance)
    value = one_instance.send(attr_name)
    if attr_name.to_s != "id"
      value_type =  value.class.to_s
      if  value_type != class_type.to_s
        unless value_type == "TrueClass"|| value_type == "FalseClass"
          raise TypeError
        end
      end
    end
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