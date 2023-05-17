require "tadb"
require_relative 'PersistentAttribute'
module Persistence
  MissingIdError = Class.new(StandardError)
  module ClassMethods
      def has_one(type, named:)
        #Guardamos en attrs_to_persist los atributos con su tipo y nombre
        persistent_attribute = PersistentAttribute.new(type, named);
        self.attrs_to_persist[named] = persistent_attribute

        #Creamos el atributo en la clase
        attr_accessor named
      end
      def attrs_to_persist
        unless @attrs_to_persist #Inicializamos si es nil
          @attrs_to_persist = {}
        end
        @attrs_to_persist #Devuelve el valor de attrs_to_persist
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
        # instance_variable_set de todos los campos
        row = row.first
        attrs_to_persist.each do |attr|
          var_name = "@"+attr[0].to_s
          value = row[attr[0]]
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
          attrs_to_persist.each do |attr|
            var_name = "@"+attr[0].to_s
            value = entry[attr[0]]
            new_obj.instance_variable_set(var_name, value)
          end
          entries_as_objects << new_obj
        end
        entries_as_objects
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
