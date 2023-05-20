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
    second_table_name = object_list[0].class.name.downcase
    intermediate_table_name = "#{table_name}_#{second_table_name}"
    object_list.each do |object|
      id = object.save!
      hash = {"id_#{table_name}": table_id, "id_#{second_table_name}": id}
      TADB::DB.table(intermediate_table_name).insert(hash)
    end
  end
  def value_is_persistent
    self.class_type.respond_to?(:has_one)
  end
end