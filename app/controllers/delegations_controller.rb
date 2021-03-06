class DelegationsController < ApplicationController
  before_action :set_delegation, only: [:show, :edit, :update, :destroy]
  before_action :set_grouped_voters, only: [:new, :edit]

  # GET /delegations
  # GET /delegations.json
  def index
    @delegations = Delegation.all
  end

  # GET /delegations/1
  # GET /delegations/1.json
  def show
  end

  # GET /delegations/new
  def new
    @delegation = Delegation.new
    @delegation.delegation_entries.build
  end

  # GET /delegations/1/edit
  def edit
  end

  # POST /delegations
  # POST /delegations.json
  def create
    @delegation = Delegation.new(delegation_params.merge(voter: current_user))

    respond_to do |format|
      if @delegation.save
        format.html { redirect_to @delegation, notice: 'Delegation was successfully created.' }
        format.json { render :show, status: :created, location: @delegation }
      else
        format.html { render :new }
        format.json { render json: @delegation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /delegations/1
  # PATCH/PUT /delegations/1.json
  def update
    respond_to do |format|
      if @delegation.update(delegation_params)
        format.html { redirect_to @delegation, notice: 'Delegation was successfully updated.' }
        format.json { render :show, status: :ok, location: @delegation }
      else
        format.html { render :edit }
        format.json { render json: @delegation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /delegations/1
  # DELETE /delegations/1.json
  def destroy
    @delegation.destroy
    respond_to do |format|
      format.html { redirect_to delegations_url, notice: 'Delegation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delegation
      @delegation = Delegation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def delegation_params
      params.require(:delegation).permit(
        delegation_entries_attributes: [ :position, :delegate_type, :delegate_id, :id ], tag_list: [])
    end

    def set_grouped_voters
      @grouped_voters = Voter.all
        .group_by { |voter| voter.type }
        .map { |type, voters| [type, voters.map { |voter| [voter.display, voter.id]}] }
      #=> [
      #     ["User", [
      #       ["Congress", 2], ["Will", 1]
      #     ]],
      #     ["Organization", [
      #       ["Library of Congress", 1]
      #     ]]
      #   ]
    end
end
