class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:show, :edit, :update, :destroy, :invite_to, :edit_member, :update_member,:destroy_invite, :destroy_member]

  # GET /companies
  # GET /companies.json
  def index
    @company = Company.new
    @companies = current_user.companies.order("company_id desc")
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)
    @company.users << current_user
    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
        format.js{render :layout => false}
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
        format.js{render :layout => false}
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
        format.js {render :layout => false}
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
        format.js {render :layout => false}
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def edit_member
  @member = @company.users_companies.find_by(:user_id => params[:member])
  respond_to do |format|       
        format.js {render :layout => false}
    end 
  end

  def update_member
    @member = @company.users_companies.find_by(:user_id => params[:users_company][:user_id])
    @member.update_attribute('role', params[:users_company][:role])
    respond_to do |format|
        format.js {render :layout => false}
    end
  end
  

  def destroy_member
    @member = @company.users_companies.find_by(:user_id => params[:member])
      @member.destroy
      respond_to do |format|
        format.html { redirect_to @company, notice: 'Member was successfully destroyed.' }
        format.json { render :show, status: :deleted, location: @company }
        format.json { head :no_content }
      end
  end

  def invite_to
    params[:company][:members_emails].compact.each do |email|
      next unless email.present?
      invite = Invite.new(:sender_id => current_user.id, :email => email, :company_id => @company.id)
      next if @company.users.include?(invite.recipient)
      if invite.save
        if invite.recipient != nil
          @company.users <<  invite.recipient
          @company.save!
          InviteMailer.existing_user_invite(invite).deliver_now
        else
          InviteMailer.new_user_invite(invite, new_user_registration_url(:invite_token => invite.token)).deliver_now
        end
      end
    end
    redirect_to :back
  end

  def destroy_invite
    @invite = Invite.find(params[:invite])
      @invite.destroy
      respond_to do |format|
        format.html { redirect_to @company, notice: 'Member was successfully destroyed.' }
        format.json { render :show, status: :deleted, location: @company }
        format.json { head :no_content }
      end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :number_of_employees, :address)
    end
end
