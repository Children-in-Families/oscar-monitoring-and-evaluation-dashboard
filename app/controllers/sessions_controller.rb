class SessionsController < Devise::SessionsController
  before_action :set_whodunnit, :detect_browser

  def new
    if request.subdomain == 'mande'
      redirect_to root_url(host: request.domain, subdomain: 'mande')
    else
      super
    end
  end

  def sign_out
    session.delete :locale
    super
  end

  def set_whodunnit
    if current_user
      PaperTrail::Version.where(item_id: current_user.id, whodunnit: nil).each do |v|
        v.update(whodunnit: current_user.id)
      end
    end
  end

  def detect_browser
    lang = params[:locale] || locale.to_s
    if browser.firefox? && browser.platform.mac? && lang == 'km'
      flash.clear
      flash[:alert] = "Application is not translated properly for Firefox on Mac, we're sorry to suggest to use Google Chrome browser instead."
    end
  end
end
