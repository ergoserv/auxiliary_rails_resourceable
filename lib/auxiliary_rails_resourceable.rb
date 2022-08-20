require_relative 'auxiliary_rails_resourceable/version'

require 'pagy'
require 'pundit'

require_relative 'auxiliary_rails/concerns/resourceable'

module AuxiliaryRailsResourceable
  class Error < StandardError; end
end
