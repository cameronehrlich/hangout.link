require 'subdomain_validator'

class User < ActiveRecord::Base

	after_create :new_hangout_link

	devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable
	
	validates :subdomain, presence: true, uniqueness: true, allow_blank: true, subdomain: true

	def self.find_for_google_oauth2(access_token, signed_in_resource=nil)

		data = access_token.info
		user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
		if user
			return user
		else
			registered_user = User.where(:email => access_token.info.email).first
			if registered_user
				return registered_user
			else

				google_credentials = access_token["credentials"]
				unique_subdomain = User.generate_unique_subdomain(data["name"].split[0])

				user = User.create(
					name: data["name"],
					provider: access_token.provider,
					email: data["email"],
					image: data["image"],
					subdomain: unique_subdomain,
					uid: access_token.uid,
					password: Devise.friendly_token[0, 20],
					google_token: google_credentials["token"],
					google_expires_at: google_credentials["expires_at"],
					google_expires: google_credentials["expires"]
					)
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

	def new_hangout_link
		event = {
			'summary' => "hangout.link-#{self.id}",
			'visibility' => "public",
			'start' => {
				'dateTime' => Time.now.to_datetime.rfc3339},  
				'end' => {         
					'dateTime' => 5.years.from_now.to_datetime.rfc3339}, 
				}
                
        master_user = User.find_by_email("cameronehrlich@gmail.com")

        client = Google::APIClient.new   
        
        client.authorization.access_token = master_user.google_token
        
        service = client.discovered_api('calendar', 'v3')
        
        result = client.execute(
        	:api_method => service.events.insert, 
        	:parameters => {'calendarId' => 'primary'}, 
        	:body => JSON.dump(event), 
        	:headers => {'Content-Type' => 'application/json'}
        	)

        self.hangout_url = result.data["hangoutLink"]
        self.save!

        return result
    end

end