Dir['./**/*.rb'].each do |f|
  require f
end

module Samovar
  class Error < StandardError; end
end
