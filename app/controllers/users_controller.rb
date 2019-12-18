class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |f|
      f.html do
        users        = list_users_filter
        authorize User
        @users_count = users.count
        @users       = Kaminari.paginate_array(users).page(params[:page]).per(20)
      end
      f.json { render json: UsersDatatable.new(view_context)}
    end
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user
    if @user.save
      if current_user.admin?
        redirect_to @user, notice: t('.successfully_created')
      else
        redirect_to root_path
      end
    else
      render :new
    end
  end

  def show
    authorize @user
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    if @user.update_attributes(user_params)
      if current_user.admin?
        redirect_to @user, notice: t('.successfully_updated')
      else
        redirect_to root_path
      end
    else
      render :edit
    end
  end

  def destroy
    authorize @user
    if @user.destroy
      redirect_to users_url, notice: t('.successfully_deleted')
    else
      redirect_to users_url, alert: t('.alert')
    end
  end

  def version
    page = params[:per_page] || 20
    @user     = User.find(params[:user_id])
    @versions = @user.versions.reorder(created_at: :desc).page(params[:page]).per(page)
  end

  def disable
    @user = User.find(params[:user_id])
    user_disable_status = @user.deactivated
    @user.deactivated = !@user.deactivated
    @user.save(validate: false)
    if user_disable_status == false
      @user.update_attributes(deactivated_at: DateTime.now.in_time_zone(Time.zone))
    elsif user_disable_status == true
      @user.update_attributes(activated_at: DateTime.now.in_time_zone(Time.zone))
    end
    redirect_to users_path, notice: t('.successfully_disable')
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :job_title, :date_of_birth, :email, :roles, :password, :password_confirmation)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def fetch_users
    users = User.all.reload
  end

  def list_users_filter
    users = users_ordered(fetch_users)
  end

  def users_ordered(users)
    users = users.sort_by(&:name)
    column = params[:order]
    return users unless column
    if %w(age_as_years id_poor).include?(column)
      ordered = users.sort_by{ |p| p.send(column).to_i }
    elsif column == 'slug'
      ordered = users.sort_by{ |p| [p.send(column).split('-').first, p.send(column)[/\d+/].to_i] }
    else
      ordered = users.sort_by{ |p| p.send(column).to_s.downcase }
    end
    column.present? && params[:descending] == 'true' ? ordered.reverse : ordered
  end
end
