module ApplicationHelper

  def current_user
    current_member
  end

  def devise_sign_in?
    controller_path == 'members/sessions' ? '' : 'display: none;'
  end

  def devise_sign_up?
    controller_path == 'members/registrations' ? '' : 'display: none;'
  end
end
