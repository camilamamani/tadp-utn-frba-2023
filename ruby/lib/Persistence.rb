require "tadb"
require_relative 'PersistentAttribute'
require_relative 'PersistentAttributeMany'
require_relative 'Table'
module Persistence
  MissingIdError = Class.new(StandardError)
  module ClassMethods
    attr_accessor :sub_classes
    def included(sub_class)
      self.sub_classes.push(sub_class)
    end
    def inherited(sub_class)
      self.sub_classes.push(sub_class)
    end
    def sub_classes
      @sub_classes||=[]
    end
    def get_attrs_from_modules_and_superclass
        modules = included_modules.select do |m|
          m.respond_to?(:attrs_to_persist)
        end
        hash = {}
        modules.each do |m|
          hash = hash.merge(m.attrs_to_persist)
        end
        if self.respond_to?(:superclass)
          super_class = self.superclass
          if super_class.include?(Persistence)
            hash = hash.merge(super_class.attrs_to_persist)
          end
        end
        hash
      end

      def get_attrs_included
        external_attrs = get_attrs_from_modules_and_superclass
        @attrs_to_persist = self.attrs_to_persist.merge(external_attrs)
      end
      def has_one(type, named:, **args)
        get_attrs_included
        attr = PersistentAttribute.new(type, named, args);
        self.attrs_to_persist[named] = attr
        attr_accessor named
        init_default_values(attrs_to_persist)
        attr
      end
      def has_many(type, named:, **args)
        get_attrs_included
        attr = PersistentAttributeMany.new(type, named, args);
        self.attrs_to_persist[named] = attr
        attr_accessor named
        init_default_values(attrs_to_persist)
      end

    def init_default_values(attrs)
      self.define_method(:initialize) do
        attrs.each do |_,attr|
          unless attr.valor_default.nil?
            self.send(attr.attr_name.to_s + '=', attr.valor_default)
          end
        end
        super()
      end
    end

      def attrs_to_persist
        @attrs_to_persist ||= {}
      end

      def save!(one_instance)
        attrs_to_persist.each do |_, attr|
          attr.validate_types(one_instance)
        end

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
          setBooleanValue(value)
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
          setBooleanValue(value)
          new_obj.instance_variable_set(var_name, value)
        end
        new_obj
      end

    def setBooleanValue(value)
      if value.to_s == "true" ? (value = true) : value; end
      if value.to_s == "false" ? (value = false) : value; end
      value
    end
      def all_instances
        objects_from_subclass = self.sub_classes.flat_map do |subclass|
          subclass.all_instances
        end

        class_name = self.name.downcase
        table = TADB::DB.table(class_name)
        entries_as_objects = []
        table.entries.each do |entry|
          entries_as_objects << get_object(entry, class_name)
        end
        entries_as_objects + objects_from_subclass
      end

      def method_missing(symbol, *args, &block)
        if symbol.to_s.start_with?('find_by_') && args.length == 1
          message = symbol.to_s.gsub('find_by_', '').to_sym
          searched_value  = args[0]

          objects_from_subclass = self.sub_classes.flat_map do |subclass|
            subclass.send(symbol, *args)
          end

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
        entries_as_objects + objects_from_subclass
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
    base.attrs_to_persist[:id] = PersistentAttribute.new(String, :id, {})
    base.send(:attr_accessor, :id)
  end
end
