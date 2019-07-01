require 'csv'
class VisitorsController < ApplicationController
  before_action :authenticate_user!, only: [:reports,  :export]

  def index
    if user_signed_in?
      @projects = current_user.projects
      @histories = History.where(:project_id => @projects).order('created_at desc').limit(10)
    else
      redirect_to new_user_session_path
    end
  end

  def reports
    @companies = current_user.companies 
    @clients = Client.where(:company_id => @companies)   
    @resources = UsersCompany.where(:company_id => @companies)
    puts @resources.inspect
    year = params['year'] || Time.now.year
    company = Company.find_by(:id => params['company'])
    client = Client.find_by(:id => params['client'])
    month = params['month'].to_i
    resources_id = params['resources']
    dataset = []
    if company.present? == false
        @projects = current_user.projects
        puts @projects
        puts "xx"
    else
        if client.present? 
            @projects = client.projects
            puts @projects
            puts "xx2"
        else
            @projects = company.projects 
            puts @projects
            puts "xx3"
        end
    end
    total_hours_calculated = 0
    @projects.each do |project|
        total_project_hours = 0
        set = {}
        data = []
        if month.present? and month > 0 and month <= 12 
          if resources_id.present?
            project_time_track= TimeTrack.select("EXTRACT(DAY FROM work_date) AS day, EXTRACT(month from work_date) as month, EXTRACT(year from work_date) as year, sum(number_of_hours) as total_hours ").where(["project_id = ? and EXTRACT(YEAR from work_date) = ? and EXTRACT(MONTH from work_date)=? and user_id IN (?)", project.id, year, month, resources_id]).group('day','month', 'year')
          else
            project_time_track= TimeTrack.select("EXTRACT(DAY FROM work_date) AS day, EXTRACT(month from work_date) as month, EXTRACT(year from work_date) as year, sum(number_of_hours) as total_hours ").where(["project_id = ? and EXTRACT(YEAR from work_date) = ? and EXTRACT(MONTH from work_date)=?", project.id, year, month]).group('day','month', 'year')
          end
            (1..31).each do |day|
              total_hours = 0
              project_time_track.each do | track_time |
                if day == track_time.day
                  total_hours = track_time.total_hours
                  break
                end
              end
              total_hours_calculated += total_hours
              total_project_hours += total_hours
              data << {value: total_hours == 0 ? nil : total_hours}
            end
            set['data'] = data
          dataset << set
        else
          if resources_id.present?
            project_time_track= TimeTrack.select("EXTRACT(month from work_date) as month, EXTRACT(year from work_date) as year, sum(number_of_hours) as total_hours").where(["project_id = ? and EXTRACT(YEAR from work_date) = ? and user_id IN (?)", project.id, year, resources_id]).group('month', 'year')
          else
            project_time_track= TimeTrack.select("EXTRACT(month from work_date) as month, EXTRACT(year from work_date) as year, sum(number_of_hours) as total_hours").where(["project_id = ? and EXTRACT(YEAR from work_date) = ?", project.id, year ]).group('month','year').order('month')
          end
          puts project_time_track.inspect
          (1..12).each do |month_number|
              total_hours = 0
              project_time_track.each do | track_time |
                  if month_number == (track_time.month).to_i
                      total_hours = track_time.total_hours
                      break
                  end
              end
              total_hours_calculated += total_hours
              total_project_hours += total_hours
              data << {value: total_hours == 0 ? nil : total_hours}
          end
          set['data'] = data
          dataset << set
        end
        set['seriesname'] = "#{project.name}-#{total_project_hours} hrs"
    end

    if (month.present? == false) or (month.present? and month == 0)
        @chart = Fusioncharts::Chart.new({
         width: "100%",
         height: "400",
         type: "mscolumn2d",
         renderAt: "chartContainer",
         dataSource: {
             chart: {
                 caption: "Time Spent on various projects",
                 subCaption: "",
                 xAxisname: "Project",
                 yAxisName: "Duration (hrs)",
                 numberSuffix: " hrs",
                 theme: "fint",
                 exportEnabled: "1",
                 placeValuesInside: "0",
                 rotateValues: "0",
                 valueFontColor: "#333333"
                 },
             annotations: {
                      origw: "400",
                      origh: "300",
                      autoscale: "1",
                      groups: [
                          {
                              id: "total-hours",
                              items: [
                                  {
                                    id: "dyn-labelBG",
                                    type: "rectangle",
                                    radius: "3",
                                    x: "$canvasEndX - 120",
                                    y: "$canvasStartY",
                                    tox: "$canvasEndX",
                                    toy: "$canvasStartY + 30",
                                    color: "#0075c2",
                                    alpha: "70"
                                  },
                                  {
                                      id: "dyn-label",
                                      type: "text",
                                      text: "Total Hours: #{total_hours_calculated} hrs",
                                      fillcolor: "#ffffff",
                                      fontsize: "10",
                                      x: "$canvasEndX - 50",
                                      y: "$canvasStartY + 15"
                                  }
                              ]
                          }
                      ]
                  },
                 categories: [{
                  category: [
                      { label: "Jan" },
                      { label: "Feb" },
                      { label: "Mar" },
                      { label: "Apr" },
                      { label: "May" },
                      { label: "Jun" },
                      { label: "Jul" },
                      { label: "Aug" },
                      { label: "Sep" },
                      { label: "Oct" },
                      { label: "Nov" },
                      { label: "Dec" }
                  ]
                  }],
                  dataset: dataset
              }
        })
    else
        @chart = Fusioncharts::Chart.new({
         width: "100%",
         height: "400",
         type: "mscolumn2d",
         renderAt: "chartContainer",
         dataSource: {
             chart: {
                 caption: "Time Spent on various projects",
                 subCaption: "",
                 xAxisname: "Project",
                 yAxisName: "Duration (hrs)",
                 numberSuffix: " hrs",
                 theme: "fint",
                 exportEnabled: "1",
                 placeValuesInside: "0",
                 rotateValues: "0",
                 valueFontColor: "#333333"
                 },
             annotations: {
                 origw: "400",
                 origh: "300",
                 autoscale: "1",
                 groups: [
                     {
                         id: "total-hours",
                         items: [
                             {
                                 id: "dyn-labelBG",
                                 type: "rectangle",
                                 radius: "3",
                                 x: "$canvasEndX - 120",
                                 y: "$canvasStartY",
                                 tox: "$canvasEndX",
                                 toy: "$canvasStartY + 30",
                                 color: "#0075c2",
                                 alpha: "70"
                             },
                             {
                                 id: "dyn-label",
                                 type: "text",
                                 text: "Total Hours: #{total_hours_calculated} hrs",
                                 fillcolor: "#ffffff",
                                 fontsize: "10",
                                 x: "$canvasEndX - 50",
                                 y: "$canvasStartY + 15"
                             }
                         ]
                     }
                 ]
             },
                 categories: [{
                  category: [
                      { label: "1" },
                      { label: "2" },
                      { label: "3" },
                      { label: "4" },
                      { label: "5" },
                      { label: "6" },
                      { label: "7" },
                      { label: "8" },
                      { label: "9" },
                      { label: "10" },
                      { label: "11" },
                      { label: "12" },
                      { label: "13" },
                      { label: "14" },
                      { label: "15" },
                      { label: "16" },
                      { label: "17" },
                      { label: "18" },
                      { label: "19" },
                      { label: "20" },
                      { label: "21" },
                      { label: "22" },
                      { label: "23" },
                      { label: "24" },
                      { label: "25" },
                      { label: "26" },
                      { label: "27" },
                      { label: "28" },
                      { label: "29" },
                      { label: "30" },
                      { label: "31" }
                  ]
                  }],
                  dataset: dataset
              }
        })
    end
  if request.xhr?
      render :text => @chart.render()
  end   
end
def export
  @companies = current_user.companies 
  @clients = Client.where(:company_id => @companies)   
  @resources = UsersCompany.where(:company_id => @companies)
  puts @resources.inspect
  year = params['year'] || Time.now.year
  company = Company.find_by(:id => params['company'])
  client = Client.find_by(:id => params['client'])
  month = params['month'].to_i
  resources_id = params['resources']
  if company.present? == false
    @projects = current_user.projects
    puts @projects
    puts "xx"
  else
    if client.present? 
      @projects = client.projects
      puts @projects
      puts "xx2"
    else
      @projects = company.projects 
      puts @projects
      puts "xx3"
    end
  end
  project_time_track = []
  @projects.each do |project|
    if month.present? and month > 0 and month <= 12 
      if resources_id.present?
        project_time_track << TimeTrack.where(["project_id = ? and EXTRACT(YEAR from work_date)  = ? and EXTRACT(MONTH from work_date) =? and user_id IN (?)", project.id, year, month, resources_id]).to_a
      else
        project_time_track << TimeTrack.where(["project_id = ? and EXTRACT(YEAR from work_date)  = ? and EXTRACT(MONTH from work_date) =?", project.id, year, month]).to_a
      end
    else
      if resources_id.present?
        project_time_track << TimeTrack.where(["project_id = ? and EXTRACT(YEAR from work_date)  = ? and user_id IN (?)", project.id, year, resources_id]).to_a
      else
        project_time_track << TimeTrack.where(["project_id = ? and EXTRACT(YEAR from work_date)  = ?", project.id, year ]).to_a
      end
    end
  end
  all_project_time_tracks = []
  project_time_track.flatten.uniq.each{|t|
   all_project_time_tracks << t 
  }
  send_data csv_data(all_project_time_tracks), :type => 'text/csv; charset=iso-8859-1; header=present',
  :disposition => "attachment; filename=export_#{Time.now}.csv"
end

private

def csv_data(time_tracks)
  csv_content = CSV.generate do |csv|
      csv << ['Work Date', 'User', 'Project', 'Client', 'Company', 'Description', 'Hours', 'Labels']
      time_tracks.each do |item|
        csv << [item.work_date, item.user.name, item.project.name, item.project.client.name, item.project.client.company.name, item.description, item.number_of_hours, item.labels.map(&:name).join(',') ]
      end
    end
  return csv_content
end
end
