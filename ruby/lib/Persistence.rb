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
        table = TADB::DB.table(class_name)
        row = table.entries.select do |entry|
          entry[:id] == one_instance.id
        end

        row = row.first
        attrs_to_persist.each do |name, _ |
          var_name = "@"+name.to_s
          value = row[name]
          one_instance.instance_variable_set(var_name, value)
        end

      end

      def forget!(instance)
        class_name = instance.class.name.downcase
        table = TADB::DB.table(class_name)
        table.delete(instance.id)
        instance.instance_variable_set("@id", nil)
      end
      def all_instances
        class_name = self.name.downcase
        table = TADB::DB.table(class_name)
        entries_as_objects = []
        table.entries.each do |entry|
          new_obj = self.new()
          attrs_to_persist.each do |name,_|
            var_name = "@"+name.to_s
            value = entry[name]
            new_obj.instance_variable_set(var_name, value)
          end
          entries_as_objects << new_obj
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
