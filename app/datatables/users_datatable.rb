class UsersDatatable
  include Rails.application.routes.url_helpers
  delegate :params, :link_to, :url_helpers, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: User.count,
      iTotalDisplayRecords: users.total_count,
      aaData: data
    }
  end

private

  def data
    users.map do |user|
      [
        user.id,
        link_to(user.name, user),
        user.email,
        [
          link_to("<i class='fa fa-pencil'></i>".html_safe, edit_user_path(user), class: 'btn btn-outline btn-success btn-xs'),
          link_to("<i class='fa fa-#{ user.deactivated ? 'lock' : 'unlock' }'></i>".html_safe, user_disable_path(user), class: 'btn btn-outline btn-primary btn-xs'),
          link_to("<i class='fa fa-trash'></i>".html_safe, user_path(user), class: 'btn btn-outline btn-danger btn-xs', method: :delete, data: { confirm: I18n.t('users.actions.are_you_sure') })
        ].join('&nbsp;&nbsp; '),
        link_to(I18n.t('users.index.view'), user_version_path(user))
      ]
    end
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    users = User.order("#{sort_column} #{sort_direction}")
    users = users.page(page)
    if params[:sSearch].present?
      users = users.where("first_name like :search or last_name like :search or email like :search", search: "%#{params[:sSearch]}%")
    end
    users
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id first_name email]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
