class TimeTracksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_time_track, only: [:show, :edit, :update, :destroy]

  # GET /time_tracks
  # GET /time_tracks.json
  def index
    admin_projects = current_user.projects.where(:users_companies => {:role => 'Admin'})
    if request.xhr?
      if params[:filter] == '7d'
        @time_tracks = TimeTrack.where(["(user_id = ? OR  project_id IN (?)) AND work_date <= ? AND work_date >= ? ",
                                      current_user.id, admin_projects.map(&:id), Date.today, (Date.today - 6.days)]).order("work_date desc")
      elsif params[:filter] == '0m'
        @time_tracks = TimeTrack.where(["(user_id = ? OR  project_id IN (?)) AND work_date <= ? AND work_date >= ? ",
                                        current_user.id, admin_projects.map(&:id), Date.today.end_of_month, Date.today.beginning_of_month]).order("work_date desc")
      elsif params[:filter] == '1m'
        @time_tracks = TimeTrack.where(["(user_id = ? OR  project_id IN (?)) AND work_date <= ? AND work_date >= ? ",
                                        current_user.id, admin_projects.map(&:id), Date.today, 1.month.ago.beginning_of_month]).order("work_date desc")
      elsif params[:filter] == '3m'
        @time_tracks = TimeTrack.where(["(user_id = ? OR  project_id IN (?)) AND work_date <= ? AND work_date >= ? ",
                                        current_user.id, admin_projects.map(&:id), Date.today, 3.months.ago.beginning_of_month]).order("work_date desc")
      elsif params[:filter] == '6m'
        @time_tracks = TimeTrack.where(["(user_id = ? OR  project_id IN (?)) AND work_date <= ? AND work_date >= ? ",
                                        current_user.id, admin_projects.map(&:id), Date.today, 6.months.ago.beginning_of_month]).order("work_date desc")
      elsif params[:filter] == '9m'
        @time_tracks = TimeTrack.where(["(user_id = ? OR  project_id IN (?)) AND work_date <= ? AND work_date >= ? ",
                                        current_user.id, admin_projects.map(&:id), Date.today, 9.months.ago.beginning_of_month]).order("work_date desc")
      elsif params[:filter] == '1y'
        @time_tracks = TimeTrack.where(["(user_id = ? OR  project_id IN (?)) AND work_date <= ? AND work_date >= ? ",
                                        current_user.id, admin_projects.map(&:id), Date.today, 1.year.ago.beginning_of_month]).order("work_date desc")
      elsif params[:filter] == '0'
        @time_tracks = TimeTrack.where(["user_id = ? OR  project_id IN (?)", current_user.id, admin_projects.map(&:id)]).order("work_date desc")
      end
      render :partial => 'time_track', :collection => @time_tracks
    else
      @time_track = TimeTrack.new
      @time_tracks = TimeTrack.where(["((user_id = ?) OR (project_id IN (?))) AND (work_date <= ? AND work_date >= ?)",
                                        current_user.id, admin_projects.map(&:id), Date.today, Date.today.beginning_of_month]).order("work_date desc")
    end
  end

  # GET /time_tracks/1
  # GET /time_tracks/1.json
  def show
  end

  # GET /time_tracks/new
  def new
    @time_track = TimeTrack.new
  end

  # GET /time_tracks/1/edit
  def edit 
    respond_to do |format|       
        format.js {render :layout => false}
    end  
  end

  # POST /time_tracks
  # POST /time_tracks.json
  def create
    @time_track = TimeTrack.new(time_track_params)
    @time_track.user_id = current_user.id if current_user
    labels = params["label"] || []
    labels.each do |name|
      l = Label.find_or_create_by(:name => name.strip.downcase)
      @time_track.labels << l
    end
    respond_to do |format|
      if @time_track.save
        History.add_history(@time_track, current_user, 'new_timetrack')
        format.html { redirect_to @time_track, notice: 'Time track was successfully created.' }
        format.json { render :show, status: :created, location: @time_track }
        format.js {render :layout => false}
      else
        format.html { render :new }
        format.json { render json: @time_track.errors, status: :unprocessable_entity }
        format.js{render :layout => false}
      end
    end
  end

  # PATCH/PUT /time_tracks/1
  # PATCH/PUT /time_tracks/1.json
  def update
    if params["label"].present?
      params["label"].each do |name|
        l = Label.find_or_create_by(:name => name.strip.downcase)
        @time_track.labels << l
      end
    end
    respond_to do |format|
      if @time_track.update(time_track_params)
        History.add_history(@time_track, current_user, 'update_timetrack')
        format.html { redirect_to @time_track, notice: 'Time track was successfully updated.' }
        format.js {render :layout => false}
      else
        format.html { render :edit }
        format.json { render json: @time_track.errors, status: :unprocessable_entity }
        format.js{ render :layout => false }
      end
    end
  end

  # DELETE /time_tracks/1
  # DELETE /time_tracks/1.json
  def destroy
    @time_track.destroy
    respond_to do |format|
      History.add_history(@time_track, current_user, 'delete_timetrack')
      format.html { redirect_to time_tracks_url, notice: 'Time track was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def label_search
    labels = Label.where("name LIKE ? ", "%#{params[:search].downcase.strip}%")
    if labels.present?
      result = []
      labels.each{|l|
        result << {:id => l.name, :name => l.name.capitalize}
      }
    else
      if params[:search].present?
        result = [{:id => params[:search], :name => params[:search].capitalize}]
      end
    end
    render :json => {:labels => result}
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_track
      @time_track = TimeTrack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_track_params
      params.require(:time_track).permit(:project_id, :user_id, :number_of_hours, :description, :work_date)
    end
end
