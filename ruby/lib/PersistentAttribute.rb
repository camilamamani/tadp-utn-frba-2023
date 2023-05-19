class PersistentAttribute
  attr_accessor :class_type, :attr_name
  def initialize(class_type, attribute)
    @class_type = class_type
    @attr_name = attribute
  end

  def get_hash_attr_value(one_instance)
    hash = {}
    value = one_instance.send(attr_name)
    value = (value.nil? && attr_name.to_s != "id") ? "..." : value
    if !value.nil? && value_is_persistent
        if value.id.nil?
          value = value.save!
        else
          value = value.id
        end
    end
    hash[attr_name] = value
    hash
    #TODO: raise error if value nil
  end

  def value_is_persistent
    self.class_type.respond_to?(:has_one)
  end
end