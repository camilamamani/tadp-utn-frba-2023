class PersistentAttributeMany < PersistentAttribute
  def initialize(class_type, attribute)
    super(class_type, attribute)
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

end