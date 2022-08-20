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
        before_action :resource, only: %i[show edit destroy] do
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
        @q = collection.ransack(params[:q])
        @q.sorts = default_sorts if @q.sorts.empty?
        @pagy, @pagy_records = pagy(@q.result(distinct: true))
      end

      def new
        self.resource = build_resource
      end

      def create
        self.resource = build_resource(resource_params)

        authorize resource

        if resource.save
          redirect_to resource_path(resource),
            notice: t('resources.create.notice',
              resource_name: resource_class.model_name.human)
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

        authorize resource

        if resource.save
          redirect_to resource_path(resource),
            notice: t('resources.update.notice',
              resource_name: resource_class.model_name.human)
        else
          render :edit
        end
      end

      def destroy
        resource.destroy

        redirect_to collection_path,
          notice: t('resources.destroy.notice',
            resource_name: resource_class.model_name.human)
      end

      protected

      # config

      def default_sorts
        %w[name title id].find { |v| v.in?(resource_class.column_names) } || []
      end

      def id_param
        params[:id]
      end

      def collection_name
        @collection_name ||= controller_name
      end

      def resource_class
        @resource_class ||= resource_name.camelize.constantize
      end

      def resource_name
        @resource_name ||= collection_name.singularize
      end

      # helpers

      def collection
        instance_variable_get("@#{collection_name}") ||
          (self.collection = resource_scope)
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

      def resource_scope
        policy_scope(resource_class.all)
      end

      def build_resource(attributes = {})
        resource_class.new(attributes)
      end

      def find_resource
        resource_class.find(id_param)
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

      # system

      def controller_module_parent
        if Rails.version < '6'
          raise NotImplementedError,
            '`controller_module_parent` needs to be implented because ' \
              'Rails < 6 does not supports `module_parent`'
        end

        self.class.module_parent
      end

      # rubocop:disable Metrics/MethodLength
      def path_method_name(type, action = nil)
        path_parts = [
          'path',
          (type.to_sym == :resource ? resource_name : controller_name)
        ]

        if controller_module_parent != Object
          path_parts << controller_module_parent.to_s.underscore
        end
        if action.present?
          path_parts << action
        end

        path_parts.reverse.join('_')
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
