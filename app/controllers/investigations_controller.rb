class InvestigationsController < ApplicationController
  before_action :validar_acesso
  def new
    @investigation = Investigation.new
    @servant = Servant.find_by(user_id: current_user.id)
  end

  def create
    @expert = Expert.find(params[:expert_id])
    @investigation = Investigation.new(investigation_params)
    @investigation.cost = 'Aceite pendente'
    if @investigation.save
      flash[:notice] = "O perito receberá um convite por email"
      redirect_to @investigation
    else
      flash[:alert] = @investigation.errors.messages.join('<br>').html_safe
      render 'new'
    end
  end

  private

  def investigation_params
    params.require(:investigation).permit(:proc_number, :servant, :call_date)
  end

  def validar_acesso
    @expert = Expert.find(params[:expert_id])
    unless (2..3).to_a.include?(current_user.profile)
      flash[:alert] = 'Não autorizado'
      redirect_to root_path
    end
  end
end
