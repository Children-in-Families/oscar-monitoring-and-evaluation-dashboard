class DataTrackersController < ApplicationController
  before_action :find_form_type, :find_item_type, only: :index

  def index
    page = params[:per_page] || 20
    if @item_type.present?
      if @form_type.present?
        @versions = filter_custom_field_versions
      else
        @versions = PaperTrail::Version.where(item_type: params[:item_type])
      end
    else
      @versions = PaperTrail::Version.where(item_type: 'User')
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
    PaperTrail::Version
    .where(item_type: @item_type)
    .where("object ILIKE '%custom_formable_type: #{@form_type}%' OR object_changes ILIKE '%custom_formable_type:\n- \n- #{@form_type}%'")
  end

end
