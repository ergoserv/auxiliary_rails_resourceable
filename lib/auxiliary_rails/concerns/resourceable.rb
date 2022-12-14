module AuxiliaryRails
  module Concerns
    # Resourceable - concern for controllers
    module Resourceable
      extend ActiveSupport::Concern
      include Pagy::Backend
      include Pundit::Authorization

      included do
        before_action only: %i[index new] do
          authorize resource_class
        end
        before_action :resource, only: %i[show edit] do
          authorize resource
        end

        after_action :verify_authorized
        after_action :verify_policy_scoped, only: %i[index]

        helper_method :collection
        helper_method :collection_path
        helper_method :resource
        helper_method :resource_class
        helper_method :resource_params
        helper_method :resource_path
        helper_method :new_resource_path
      end

      def index
        @ransack = collection.ransack(search_params)
        @ransack.sorts = default_sorts if @ransack.sorts.empty?
        @pagy, self.collection = pagy(@ransack.result)
      end

      def new
        self.resource = build_resource
      end

      def create
        if create_resource(resource_params)
          redirect_after_create
        else
          render :new
        end
      end

      def show
      end

      def edit
      end

      def update
        if update_resource(resource_params)
          redirect_after_update
        else
          render :edit
        end
      end

      def destroy
        destroy_resource

        redirect_after_destroy
      end

      protected

      # configs

      def default_sorts
        %w[name title id].find { |v| v.in?(resource_class.column_names) } || []
      end

      # Defines an I18n scope for flash messages
      #
      # Use `controller_name` for scoping as the name of the controller.
      def i18n_scope
        :resources
      end

      def id_param
        params[:id]
      end

      def search_params
        params[:q]
      end

      def collection_name
        @collection_name ||= controller_name
      end

      def collection_scope
        policy_scope(resource_class).all
      end

      def resource_class
        @resource_class ||= resource_name.camelize.constantize
      end

      def resource_name
        @resource_name ||= collection_name.singularize
      end

      # actions

      def build_resource(attributes = {})
        resource_class.new(attributes)
      end

      def create_resource(attributes = {})
        self.resource = build_resource(attributes)

        authorize resource, :create?

        resource.save
      end

      def find_resource
        resource_class.find(id_param)
      end

      def update_resource(attributes = {})
        resource.assign_attributes(attributes)

        authorize resource, :update?

        resource.save
      end

      def destroy_resource
        authorize resource, :destroy?

        resource.destroy
      end

      # helpers

      def collection
        instance_variable_get("@#{collection_name}") ||
          (self.collection = collection_scope)
      end

      def collection=(object)
        instance_variable_set("@#{collection_name}", object)
      end

      def resource
        instance_variable_get("@#{resource_name}") ||
          (self.resource = find_resource)
      end

      def resource=(object)
        instance_variable_set("@#{resource_name}", object)
      end

      def resource_params
        params
          .require(resource_name)
          .permit(policy(resource_class).permitted_attributes)
      end

      def collection_path
        public_send(path_method_name(:collection))
      end

      def resource_path(resource, action = nil)
        public_send(path_method_name(:resource, action), resource)
      end

      def new_resource_path
        public_send(path_method_name(:resource, :new))
      end

      # redirects

      def redirect_after_create
        redirect_to resource_path(resource),
          notice: t('create.notice',
            resource_name: resource_class.model_name.human,
            scope: i18n_scope)
      end

      def redirect_after_update
        redirect_to resource_path(resource),
          notice: t('update.notice',
            resource_name: resource_class.model_name.human,
            scope: i18n_scope)
      end

      def redirect_after_destroy
        redirect_to collection_path,
          notice: t('destroy.notice',
            resource_name: resource_class.model_name.human,
            scope: i18n_scope)
      end

      # system

      def controller_module_parent_name
        if Rails.version < '6'
          return self.class.parent_name
        end

        self.class.module_parent_name
      end

      def path_method_name(type, action = nil)
        [
          action,
          controller_module_parent_name&.underscore,
          (type.to_sym == :resource ? resource_name : controller_name),
          'path'
        ].compact.join('_')
      end
    end
  end
end
