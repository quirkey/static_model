if defined?(Rails)
  module StaticModel
    class Base
      @@load_path = File.join(Rails.root,'config', 'data')
    end
  end
end