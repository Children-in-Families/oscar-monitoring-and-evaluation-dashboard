class ApplicationController < ActionController::Base
  include Pundit

  before_action :authenticate_user!
  protect_from_forgery with: :null_session, except: :index, if: proc { |c| c.request.format == 'application/json' }

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError do |exception|
    redirect_to root_url, alert: 'You are not authorized to access this page.'
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge(options)
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_url
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :date_of_birth, :job_title, :mobile])
    end

  private

    def set_locale
      locale = I18n.available_locales.include?(params[:locale].to_sym) ? params[:locale] : I18n.locale if params[:locale].present?
      I18n.locale = locale || I18n.locale
    end
end
