# frozen_string_literal: true

require 'quasar_scaffold/version'
require 'quasar_scaffold/configuration'
require 'quasar_scaffold/route_drawing'
require 'quasar_scaffold/engine'

module QuasarScaffold
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    # Returns the absolute path to the gem's frontend/ directory.
    # Used by the rake task to write the path for the Vite alias.
    def frontend_path
      File.expand_path('../frontend', __dir__)
    end

    # Called by the engine's to_prepare hook.
    # Dynamically creates response classes, serializers, and controllers
    # for each resource module in configuration.resource_modules.
    def init
      api_mod = configuration.api_version_module
      raise ArgumentError, 'QuasarScaffold: configure must set api_version_module before init' if api_mod.nil?

      configuration.resource_modules.each do |module_name|
        module_const = module_constant(module_name)
        module_classes = module_const.constants

        MODEL_RESPONSE_CLASSES.each do |klass|
          next if module_classes.include?(klass.to_s.to_sym)

          module_const.const_set(klass.to_s, Class.new(klass))
        end

        unless module_classes.include?(:IndexSerializer)
          IndexSerializerFactory.create_class(module_const, 'IndexSerializer')
        end

        next if api_mod.constants.include?(:"#{module_name}Controller")

        klass = api_mod.const_set(
          :"#{module_name}Controller",
          Class.new(api_mod::BaseModelController)
        )
        klass.const_set(:MODULE, module_name.constantize)
      end
    end

    def module_constant(module_name)
      module_name.constantize
    rescue NameError
      Object.const_set(module_name, Module.new)
    end
  end

  MODEL_RESPONSE_CLASSES = [
    IndexResponse,
    CreateResponse,
    EditResponse,
    UpdateResponse,
    BatchUpdateResponse,
    ShowResponse,
    ImportResponse,
    DestroyResponse,
    DatatableOptionsResponse,
  ].freeze
end
