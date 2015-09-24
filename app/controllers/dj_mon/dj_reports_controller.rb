module DjMon
  class DjReportsController < ActionController::Base

    auth_monkey_patch = Rails.configuration.dj_mon.auth_monkey_patch
    if auth_monkey_patch.present?
      instance_exec(&auth_monkey_patch)
    end

    respond_to :json, :html
    layout 'dj_mon'

    before_filter :set_api_version

    def index
    end

    def all
      respond_with json_data(:all_reports)
    end

    def failed
      respond_with json_data(:failed_reports)
    end

    def active
      respond_with json_data(:active_reports)
    end

    def queued
      respond_with json_data(:queued_reports)
    end

    def dj_counts
      respond_with DjReport.dj_counts
    end

    def settings
      respond_with DjReport.settings
    end

    def reset_all
      DjMon::Backend.reset_all
      render nothing: true
    end

    def retry
      DjMon::Backend.retry params[:id]
      respond_to do |format|
        format.html { redirect_to root_path, :notice => "The job has been queued for a re-run" }
        format.json { head(:ok) }
      end
    end

    def destroy
      DjMon::Backend.destroy params[:id]
      respond_to do |format|
        format.html { redirect_to root_path, :notice => "The job was deleted" }
        format.json { head(:ok) }
      end
    end

    protected

    def set_api_version
      response.headers['DJ-Mon-Version'] = DjMon::VERSION
    end

    private

    def json_data(scope_name)
      {
        items: DjReport.public_send(scope_name, params[:page].to_i || 1, params[:per_page].to_i || 50),
        count: DjReport.public_send(scope_name).count
      }
    end

  end

end
