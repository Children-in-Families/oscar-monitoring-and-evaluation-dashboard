module ApplicationHelper
  def whodunnit(type, id)
    user_id = PaperTrail::Version.find_by(event: 'create', item_type: type, item_id: id).try(:whodunnit)
    return 'OSCaR Team' if user_id.blank? || (user_id.present? && user_id.include?('@rotati'))
    User.find_by(id: user_id).try(:name) || ''
  end

  def flash_alert
    if notice
      { 'message-type': 'notice', 'message': notice }
    elsif alert
      { 'message-type': 'alert', 'message': alert }
    else
      {}
    end
  end

  def is_active_controller(controller_name)
    params[:controller] == controller_name ? "active" : nil
  end

  def authorized_body
    'unauthorized-background' unless user_signed_in?
  end

  def clients_menu_active
    names = %w(clients client_advanced_searches)
    any_active_menu(names)
  end

  def error_notification(f)
    content_tag(:div, t('review_problem'), class: 'alert alert-danger') if f.error_notification.present?
  end

  def current_url(new_params)
    url_for params: params.merge(new_params)
  end

  def any_active_menu(names)
    'active' if names.include? controller_name
  end

  def date_format(date)
    date.strftime('%d %B %Y') if date.present?
  end

  def current_donor_logo(klasses='')
    if current_donor.logo.attached?
      if current_donor.logo.representable?
        link_to dashboards_url(subdomain: current_donor.schema_name) do
          image_tag current_donor.logo, width: 100, class: klasses
        end
      elsif current_donor.logo.image?
        link_to image_tag(current_donor.logo, width: 100, class: klasses, style: 'background-color: white; padding: 5px;'), dashboards_url(subdomain: current_donor.schema_name), class: 'donor-logo-link'
      else
        image_tag current_donor.logo.filename.to_s, class: klasses
      end
    end
  end
end
