json.array!(@time_tracks) do |time_track|
  json.extract! time_track, :id, :project_id, :user_id, :number_of_hours, :description
  json.url time_track_url(time_track, format: :json)
end
