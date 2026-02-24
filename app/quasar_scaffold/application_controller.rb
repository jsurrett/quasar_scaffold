class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  class UnathorizedAccess < StandardError; end

  rescue_from CanCan::AccessDenied, with: :unauthorized_access
  rescue_from UnathorizedAccess, with: :unauthorized_access

  extend Memoist

  before_action :authenticate
  before_action :set_locale
  before_action :set_time_zone
  before_action :set_paper_trail_whodunnit

  private

  def authenticate
    tenant_valid = QuasarScaffold.configuration.tenant_validator.call
    raise UnathorizedAccess if !tenant_valid || jwt_token_data.blank? || current_user.blank?
  end

  def current_user
    resolver = QuasarScaffold.configuration.current_user_resolver
    return if resolver.nil?

    data = jwt_token_data['user']
    return if data.blank?

    resolver.call(data)
  end
  memoize :current_user

  def jwt_token_data
    decoder = QuasarScaffold.configuration.jwt_decoder
    header_key = QuasarScaffold.configuration.jwt_header_key
    return {} if decoder.nil?

    decoder.call(request.headers[header_key])
  rescue StandardError
    {}
  end
  memoize :jwt_token_data

  def unauthorized_access(_exception = nil)
    render(
      json: I18n.t(:'messages.unauthorized_access_attempt_detected'),
      status: :unauthorized
    )
  end

  def set_time_zone
    Time.zone = QuasarScaffold.configuration.time_zone_resolver.call
  end

  def set_locale
    locale =
      if current_user
        params[:locale] || current_user.try(:language) || I18n.default_locale.to_s
      else
        params[:locale] || QuasarScaffold.configuration.default_locale_resolver.call
      end
    I18n.locale = locale
  rescue StandardError
    I18n.locale = QuasarScaffold.configuration.default_locale_resolver.call
  end

  def append_info_to_payload(payload)
    super

    payload[:ip]     = request.remote_ip
    payload[:tenant] = QuasarScaffold.configuration.current_tenant_resolver.call
    payload[:user]   = current_user ? current_user.try(:username) : 'none'
  end
end
