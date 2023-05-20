require "tadb"
require_relative 'PersistentAttribute'
require_relative 'Table'
module Persistence
  MissingIdError = Class.new(StandardError)
  module ClassMethods
      def get_attrs_from_modules
        modules = included_modules.select do |m|
          m.respond_to?(:attrs_to_persist)
        end
        hash = {}
        modules.each do |m|
          hash = hash.merge(m.attrs_to_persist)
        end
        hash
      end
      def get_attrs_from_super_class
        hash = {}
        if self.respond_to?(:superclass)
          super_class = self.superclass
          if super_class.include?(Persistence)
            hash = super_class.attrs_to_persist
          end
        end
        hash
      end
      def get_attrs_included
        attrs_super_class = get_attrs_from_super_class
        attrs_module = get_attrs_from_modules
        @attrs_to_persist = self.attrs_to_persist.merge(attrs_module.merge(attrs_super_class))
      end
      def has_one(type, named:)
        get_attrs_included
        create_instance_variable(type, named:)
      end
      def has_many(type, named:)
        get_attrs_included
        attr = create_instance_variable(type, named:)
        self.define_method(:initialize) do
          self.send(attr.attr_name.to_s + '=', [])
          super()
        end
      end

      def create_instance_variable(type, named:)
        attr = PersistentAttribute.new(type, named);
        self.attrs_to_persist[named] = attr
        attr_accessor named
        attr
      end
      def attrs_to_persist
        @attrs_to_persist ||= {}
      end

      def save!(one_instance)
        row_id = Table.save_primitive_attributes(attrs_to_persist, one_instance)
        Table.save_objects_attributes(attrs_to_persist, one_instance, row_id)
        row_id
      end

      def refresh!(one_instance)
        class_name = one_instance.class.name.downcase
        row = find_by_table_name_and_id(class_name, one_instance.id)

        attrs_to_persist.each do |name, attr |
          var_name = "@"+name.to_s
          value = row[name]
          if attr.value_is_persistent
            value = get_object_from_persistent_value(attr, value, class_name)
          end
          one_instance.instance_variable_set(var_name, value)
        end
        one_instance
      end

      def forget!(instance)
        class_name = instance.class.name.downcase
        table = TADB::DB.table(class_name)
        table.delete(instance.id)
        instance.instance_variable_set("@id", nil)
      end
      def find_by_intermediate_table_object_entries(class_name)
        table = TADB::DB.table(class_name)
        second_table_name = class_name.split("_").last
        id_attr = "id_"+second_table_name
        table.entries.map do |id_entry|
          find_by_table_name_and_id(second_table_name, id_entry[id_attr.to_sym])
        end
      end
      def find_by_table_name_and_id(class_name, id)
        table = TADB::DB.table(class_name)
        entry = table.entries.find { |entry| entry[:id] == id }
        entry
      end

      def get_object_from_persistent_value(attr, value, class_name)
        if value == 'intermediate_table'
          second_table_name = attr.class_type.to_s.downcase
          table_name = "#{class_name}_#{second_table_name}"

          object_entries = find_by_intermediate_table_object_entries(table_name)
          value = object_entries.map do |object_entry|
            attr.class_type.get_object_from_entry(object_entry)
          end
        else
          id = value
          object_entry = find_by_table_name_and_id(attr.class_type.to_s.downcase, id)
          value = attr.class_type.get_object_from_entry(object_entry)
        end
        value
      end
      def get_object_from_entry(entry)
        new_obj = self.new()
        attrs_to_persist.each do |name,_|
          var_name = "@"+name.to_s
          value = entry[name]
          new_obj.instance_variable_set(var_name, value)
        end
        new_obj
      end

      def get_object(entry, class_name)
        new_obj = self.new()
        attrs_to_persist.each do |name, attr|
          var_name = "@"+name.to_s
          value = entry[name]
          if attr.value_is_persistent
            value = get_object_from_persistent_value(attr, value, class_name)
          end
          new_obj.instance_variable_set(var_name, value)
        end
        new_obj
      end

      def all_instances
        class_name = self.name.downcase
        table = TADB::DB.table(class_name)
        entries_as_objects = []
        table.entries.each do |entry|
          entries_as_objects << get_object(entry, class_name)
        end
        entries_as_objects
      end

      def method_missing(symbol, *args, &block)
        if symbol.to_s.start_with?('find_by_') && args.length == 1
          message = symbol.to_s.gsub('find_by_', '').to_sym
          searched_value  = args[0]

          class_name = self.name.downcase
          table = TADB::DB.table(class_name)

          entries_as_objects = []
          table.entries.each do |entry|
            if entry[message] == searched_value
              new_obj = self.new()
              attrs_to_persist.each do |name,_|
                var_name = "@"+name.to_s
                value = entry[name]
                new_obj.instance_variable_set(var_name, value)
            end
            entries_as_objects << new_obj
            end
          end
        else
          super
        end
        entries_as_objects
      end
      def respond_to_missing?(symbol, priv = false)
        symbol.to_s.start_with?('find_by_')
      end
    end
    def save!
      @id = self.class.save!(self)
    end

    def refresh!
      if @id.nil?
        raise MissingIdError
      end
      self.class.refresh!(self)
    end

  def forget!
    if @id.nil?
      raise MissingIdError
    end
    self.class.forget!(self)
  end
  def self.included(base)
    base.extend(ClassMethods)
    base.attrs_to_persist[:id] = PersistentAttribute.new(String, :id)
    base.send(:attr_accessor, :id)
  end
end
