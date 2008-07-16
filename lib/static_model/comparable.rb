module StaticModel
  module Comparable
    include ::Comparable

    def <=>(other)
      if self.class == other.class 
        self.id <=> other.id
      else
        -1
      end
    end
    
  end
end