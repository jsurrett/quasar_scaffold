# frozen_string_literal: true

module QuasarScaffold
  class Configuration
    # Required: the Rails module that API controllers live in (e.g., V1)
    attr_accessor :api_version_module

    # Required: array of CamelCase model-module name strings to scaffold
    # e.g., %w[Students Employees Families]
    attr_accessor :resource_modules

    # The request header key that carries the JWT token. Default: 'token'
    attr_accessor :jwt_header_key

    # Proc that decodes a raw JWT string and returns a hash.
    # Signature: ->(raw_token) { YourDecoder.decode(raw_token)[0] }
    attr_accessor :jwt_decoder

    # Proc that resolves the current user from decoded JWT data hash.
    # Signature: ->(data) { User.find_by(auth_token: data['auth_token']) }
    attr_accessor :current_user_resolver

    # Proc that validates the current tenant (returns true/false).
    # Default: -> { true }
    attr_accessor :tenant_validator

    # Proc that returns the default locale string when no user locale is set.
    # Default: -> { I18n.default_locale.to_s }
    attr_accessor :default_locale_resolver

    # Proc that returns the current time zone string.
    # Default: -> { 'UTC' }
    attr_accessor :time_zone_resolver

    # Proc that returns the current tenant name for logging (optional).
    # Default: -> { 'default' }
    attr_accessor :current_tenant_resolver

    # Default items per page for pagination. Default: 20
    attr_accessor :default_items_per_page

    def initialize
      @resource_modules         = []
      @jwt_header_key           = 'token'
      @jwt_decoder              = nil
      @current_user_resolver    = nil
      @tenant_validator         = -> { true }
      @default_locale_resolver  = -> { I18n.default_locale.to_s }
      @time_zone_resolver       = -> { 'UTC' }
      @current_tenant_resolver  = -> { 'default' }
      @default_items_per_page   = 20
    end
  end
end
