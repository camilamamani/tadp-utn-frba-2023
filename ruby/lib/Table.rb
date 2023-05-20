class Table
  def self.save_primitive_attributes(attrs_to_persist, one_instance)
    class_name = one_instance.class.name.downcase
    hash = {}
    attrs_to_persist.each_value do |attr|
      hash = hash.merge(attr.get_hash_attr_value(one_instance))
    end

    if one_instance.id != nil
      TADB::DB.table(class_name).delete(one_instance.id)
    end

    TADB::DB.table(class_name).insert(hash)
  end

  def self.save_objects_attributes(attrs_to_persist, one_instance, id)
    attrs_to_persist.each_value do |attr|
      value = one_instance.send(attr.attr_name)
      table_name = one_instance.class.name.downcase
      if value.is_a?(Array)
        attr.save_array(value, id, table_name)
      end
    end
  end

end