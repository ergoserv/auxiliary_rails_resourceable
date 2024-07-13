module AuxiliaryRails
  module Concerns
    # Resourceable - concern for controllers
    module Resourceable
      extend ActiveSupport::Concern
      include Pagy::Backend
      include Pundit::Authorization

      included do
        before_action :authorize_resource_class, only: %i[index new create]
        before_action :authorize_resource, only: %i[show edit update destroy]
        before_action :set_lookup_context_prefixes
        after_action :verify_authorized
        after_action :verify_policy_scoped, only: %i[index]

        helper_method :collection
        helper_method :collection_path
        helper_method :form_resource
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
        self.resource = build_resource(resource_params)

        if resource.save
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
        resource.assign_attributes(resource_params)

        if resource.save
          redirect_after_update
        else
          render :edit
        end
      end

      def destroy
        resource.destroy

        redirect_after_destroy
      end

      protected

      # configs

      def authorize_resource(query = nil, policy_class: nil)
        authorize resource, query, policy_class: policy_class
      end

      def authorize_resource_class(query = nil, policy_class: nil)
        authorize resource_class, query, policy_class: policy_class
      end

      def default_sorts
        %w[name title id].find { |v| v.in?(resource_class.column_names) } || []
      end

      # Defines an I18n scope for flash messages
      #
      # Possible options to use instead of `:resources`:
      # - `controller_name`
      # - `"#{controller_module_name}/resources"`
      # - `"#{controller_module_name}/#{controller_name}"`
      # - any other manual scope
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

      def find_resource
        resource_class.find(id_param)
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

      def form_resource
        if controller_module_name.blank?
          resource
        else
          [controller_module_name.to_sym, resource]
        end
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
        if flash[:notice].blank?
          flash[:notice] = t('create.notice',
            resource_name: resource_class.model_name.human,
            scope: i18n_scope)
        end

        redirect_to resource_path(resource)
      end

      def redirect_after_update
        if flash[:notice].blank?
          flash[:notice] = t('update.notice',
            resource_name: resource_class.model_name.human,
            scope: i18n_scope)
        end

        redirect_to resource_path(resource)
      end

      def redirect_after_destroy
        if flash[:notice].blank?
          flash[:notice] = t('destroy.notice',
            resource_name: resource_class.model_name.human,
            scope: i18n_scope)
        end

        redirect_to collection_path
      end

      # system

      def controller_module_name
        if Rails.version < '6'
          return self.class.parent_name&.underscore
        end

        self.class.module_parent_name&.underscore
      end

      def path_method_name(type, action = nil)
        [
          action,
          controller_module_name,
          (type.to_sym == :resource ? resource_name : controller_name),
          'path'
        ].compact.join('_')
      end

      def set_lookup_context_prefixes
        lookup_context.prefixes << 'resourceable'
      end
    end
  end
end
