class ApiController < ApplicationController
	def check_subdomain
		tmp_user = User.new(email: "#{SecureRandom.hex(10)}@#{SecureRandom.hex(10)}.com", password: SecureRandom.hex(10))
		tmp_user.subdomain = params[:subdomain]
		render json: {valid: tmp_user.valid?, errors: tmp_user.errors[:subdomain]}
	end
end
