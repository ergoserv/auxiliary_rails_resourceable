require 'rails/railtie'
require 'auxiliary_rails/view_helpers/human_name_helper'

module AuxiliaryRails
  class Railtie < Rails::Railtie
    initializer 'auxiliary_rails.view_helpers' do
      ActionView::Base.include AuxiliaryRails::ViewHelpers::HumanNameHelper
    end
  end
end
