require "tadb"

module Persistence
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def has_one(type, named:)
      attr_accessor named
    end
  end
end
