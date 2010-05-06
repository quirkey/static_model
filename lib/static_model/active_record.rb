module StaticModel
  module ActiveRecord
    # Stubbing out ActiveRecord methods so that associations work
    
    def new_record?
      false
    end
    
    def destroyed?
      false
    end

  end
end