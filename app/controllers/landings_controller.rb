class LandingsController < ApplicationController
  before_action :searching?
  def flower_smith 
  end

  def two_barn_farm
  end

  def csa
  end

  def farmers
  end

  def plants
  end
  private

    def searching?
      if params.has_key?(:q)
       redirect_to posts_path({q: params[:q]})
      end
    end
end