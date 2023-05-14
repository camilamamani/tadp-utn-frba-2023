require "tadb"
require_relative 'PersistentAttribute'
module Persistence
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
        #Obtenemos el nombre de la clase
        class_name = one_instance.class.name.downcase

        #Obtenemos el hash atributo valor, a partir de los attrs_to_persist
        hash = {}
        @attrs_to_persist.each_value do |attr|
          hash = hash.merge(attr.get_hash_attr_value(one_instance))
        end

        # Creamos tabla con nombre de la clase + insertamos hash con atributos y valores
        table = TADB::DB.table(class_name)
        row_id = table.insert(hash)
        row_id
      end
    end
    def save!
      @id = self.class.save!(self)
    end
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:attr_accessor, :id)
    end
end
