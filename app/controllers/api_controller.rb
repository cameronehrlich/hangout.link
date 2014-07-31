class ApiController < ApplicationController

	def check_subdomain
		render json: validate_subdomain(params[:subdomain])
	end


end
