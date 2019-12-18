class CustomFailure < Devise::FailureApp
  def redirect_url
    if request.subdomain == 'mande'
      root_url(subdomain: 'mande')
    else
      new_user_session_url(subdomain: request.subdomain)
    end
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
