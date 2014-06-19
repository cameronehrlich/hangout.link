class HomeController < ApplicationController
  def index
  	users = {
  		"cam" => "http://camehrlich.com", 
  		"samir" => "http://samir.io", 
  		"michael" => "http://michaeljackson.com"}
  	@hangout_link = users[request.subdomain]
  end
end
