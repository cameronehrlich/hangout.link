class ApplicationController < ActionController::Base
	protect_from_forgery
	def validate_subdomain subdom
		tmp_user = User.new(email: "#{SecureRandom.hex(10)}@#{SecureRandom.hex(10)}.com", password: SecureRandom.hex(10))
		tmp_user.subdomain = subdom
		return {valid: tmp_user.valid?, errors: tmp_user.errors[:subdomain]}
	end
end
