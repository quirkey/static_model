if defined?(Rails) && Rails.root
  StaticModel::Base.load_path = File.join(Rails.root,'config', 'data')
end
