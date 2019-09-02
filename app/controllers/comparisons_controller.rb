class ComparisonsController < ApplicationController

    def index
        @comparisons = Comparison.all
    end

    def create
        Comparison.create(user_id: current_user.id, inferior_id: params[:inferior][:id], superior_id: params[:superior][:id])
        redirect_to comparison_path(current_user)
    end

end
