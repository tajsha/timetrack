module CompaniesHelper
  def user_role(user, company)
    UsersCompany.find_by(:user => user, :company => company).role
  end

  def company_admin?(company, user)
    UsersCompany.find_by(:user => user, :company => company).role == 'Admin'
  end
end
