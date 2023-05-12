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
  end
  def self.included(base)
    base.extend(ClassMethods)
  end
end
