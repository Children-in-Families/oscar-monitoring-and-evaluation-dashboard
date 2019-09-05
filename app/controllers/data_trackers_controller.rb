class DataTrackersController < ApplicationController
  load_and_authorize_resource

  before_action :find_form_type, :find_item_type, only: :index

  def index
    page = params[:per_page] || 20
    binding.pry
    if @item_type.present?
      if @form_type.present?
        @versions = filter_custom_field_versions
      else
        @versions = PaperTrail::Version.where(item_type: params[:item_type])
      end
    else
      @versions = PaperTrail::Version.where.not(item_type: exclude_item_type)
    end
    @versions = @versions.order(created_at: :desc).page(params[:page]).per(page)
  end

  private

  def find_form_type
    @form_type = params[:formable_type]
  end

  def find_item_type
    @item_type = params[:item_type]
  end

  def filter_custom_field_versions
      # .where("object ILIKE '%custom_formable_type: #{@form_type}%' OR object_changes ILIKE '%custom_formable_type:\n- \n- #{@form_type}%'")
    PaperTrail::Version.where(item_type: @item_type)
  end

end
