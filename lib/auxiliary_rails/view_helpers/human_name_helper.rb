module AuxiliaryRails
  module ViewHelpers
    module HumanNameHelper
      # Human-readable name for a model or a model's attribute
      #
      # @param model [Class, Object] The model class or an instance of the model
      # @param attribute [Symbol, String, nil] The attribute name (optional)
      # @return [String] The human-readable name
      def human_name(model, attribute = nil, count: 1)
        if attribute.nil?
          model.model_name.human(count: count)
        else
          model = model.class unless model.is_a?(Class)
          if count > 1
            model.human_attribute_name(attribute).pluralize(count)
          else
            model.human_attribute_name(attribute)
          end
        end
      end

      # Human-readable name for a model or a model's attribute plural form
      #
      # @param model [Class, Object] The model class or an instance of the model
      # @param attribute [Symbol, String, nil] The attribute name (optional)
      # @return [String] The human-readable name in plural form
      def human_name_plural(model, attribute = nil, count: 2)
        human_name(model, attribute, count: count)
      end
    end
  end
end
