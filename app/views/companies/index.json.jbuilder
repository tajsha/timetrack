json.array!(@companies) do |company|
  json.extract! company, :id, :name, :number_of_employees, :address
  json.url company_url(company, format: :json)
end
