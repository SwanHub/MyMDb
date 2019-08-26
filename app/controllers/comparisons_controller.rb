class ComparisonsController < ApplicationController

    def index
        @comparisons = Comparison.all
    end

    def create
        Comparison.create(user_id: params["user"]["id"], inferior_id: params["inferior_id"], superior_id: params["superior_id"])
        redirect_to users_path
    end

end
