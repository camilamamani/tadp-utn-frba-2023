class PersistentAttribute
  attr_accessor :class_type, :attr_name
  def initialize(clase, atributo)
    @class_type = clase
    @attr_name = atributo
  end


end