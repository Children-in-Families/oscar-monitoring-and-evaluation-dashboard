module ClientsHelper
  def country_scope_label_translation
    if I18n.locale.to_s == 'en'
      country_name = "Setting.first.try(:country_name)"
      case country_name
      when 'cambodia' then '(Khmer)'
      when 'thailand' then '(Thai)'
      when 'myanmar' then '(Burmese)'
      when 'lesotho' then '(Sesotho)'
      when 'uganda' then '(Swahili)'
      else
        '(Unknown)'
      end
    end
  end
end
