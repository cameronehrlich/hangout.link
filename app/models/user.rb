require 'subdomain_validator'

class User < ActiveRecord::Base
	
	devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable
	
	validates  :subdomain, 	presence: true,
	uniqueness: true,
	allow_blank: true,
	subdomain: true

	def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
		puts access_token
		data = access_token.info
		puts access_token
		user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
		if user
			return user
		else
			registered_user = User.where(:email => access_token.info.email).first
			if registered_user
				return registered_user
			else
				
				
				unique_subdomain = User.generate_unique_subdomain(data["name"])
				user = User.create(name: data["name"],
					provider: access_token.provider,
					email: data["email"],
					image: data["image"],
					subdomain: unique_subdomain,
					uid: access_token.uid,
					password: Devise.friendly_token[0,20])
			end
		end
	end

	def self.generate_unique_subdomain(seed_string)
		seed_string = seed_string.gsub(/[^0-9a-z ]/i,'').delete(' ').downcase
		new_subdomain = seed_string
		
		count = 0
		tmp_user = User.new(email: "#{SecureRandom.hex(10)}@#{SecureRandom.hex(10)}.com", password: SecureRandom.hex(10))
		
		while not tmp_user.valid?
			tmp_user.subdomain = seed_string + count.to_s
			count += 1
		end

		return new_subdomain
	end

end