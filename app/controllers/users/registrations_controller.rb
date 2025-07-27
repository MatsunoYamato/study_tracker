class Users::RegistrationsController < Devise::RegistrationsController
  def guest_sign_in
    guest_user = User.find_by(email: 'guest@example.com')
    unless guest_user
      guest_user = User.new(
        email: 'guest@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
      guest_user.save!(validate: false)
    end
    sign_in guest_user
    redirect_to dashboard_path
  end

  protected

  def update_resource(resource, params)
    # パスワードが空白の場合は、current_passwordのチェックをしつつパスワード更新をスキップ
    if params[:password].blank? && params[:password_confirmation].blank?
      resource.update_without_password(params.except(:current_password))
    else
      resource.update_with_password(params)
    end
  end

  def after_update_path_for(_resource)
    edit_user_registration_path
  end

  private

  def account_update_params
    params.require(:user).permit(:email, :avatar, :password, :password_confirmation, :current_password)
  end
end
