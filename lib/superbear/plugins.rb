module Superbear::Plugins
end

basepath = File.expand_path('..', __FILE__)

Dir["#{basepath}/**/*.rb"].each do |plugin_file|
  require plugin_file
end
