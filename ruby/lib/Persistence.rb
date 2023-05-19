require "tadb"
require_relative 'PersistentAttribute'
module Persistence
  MissingIdError = Class.new(StandardError)
  module ClassMethods
      def has_one(type, named:)
        persistent_attribute = PersistentAttribute.new(type, named);
        self.attrs_to_persist[named] = persistent_attribute

        attr_accessor named
      end
      def attrs_to_persist
        @attrs_to_persist ||= {}
      end

      def save!(one_instance)
        class_name = one_instance.class.name.downcase

        hash = {}
        @attrs_to_persist.each_value do |attr|
          hash = hash.merge(attr.get_hash_attr_value(one_instance))
        end

        if one_instance.id != nil
          TADB::DB.table(class_name).delete(one_instance.id)
        end

        row_id = TADB::DB.table(class_name).insert(hash)
        row_id
      end

      def refresh!(one_instance)
        class_name = one_instance.class.name.downcase
        row = find_by_table_name_and_id(class_name, one_instance.id)

        attrs_to_persist.each do |name, attr |
          var_name = "@"+name.to_s
          value = row[name]
          if attr.value_is_persistent
            id = value
            object_entry = find_by_table_name_and_id(attr.class_type.to_s.downcase, id)
            value = attr.class_type.get_object_from_entry(object_entry)
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

      def find_by_table_name_and_id(class_name, id)
        table = TADB::DB.table(class_name)
        entry = table.entries.find { |entry| entry[:id] == id }
        entry
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

      def all_instances
        class_name = self.name.downcase
        table = TADB::DB.table(class_name)
        entries_as_objects = []
        table.entries.each do |entry|
          entries_as_objects << get_object_from_entry(entry)
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
