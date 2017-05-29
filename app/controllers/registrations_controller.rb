class RegistrationsController < Devise::RegistrationsController

  def new
  	if params[:user]
      build_resource({email: params[:user][:email]})
    else
      build_resource({})
    end
    set_minimum_password_length
    yield resource if block_given?
    respond_with self.resource
  end

  def create
    build_resource(sign_up_params)

    ref_code = cookies[:h_ref]
    resource.referrer = User.find_by_referral_code(ref_code) if ref_code

    resource.save
    yield resource if block_given?
    if resource.persisted?
      cookies.delete :h_ref
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def after_sign_up_path_for(resource)
    '/refer-a-friend'
  end
end