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
    hash[attr_name] = value
    hash
    #TODO: raise error if value nil
  end
end