require 'sinatra'
require 'active_model'
require 'pony'

# model gem
class BonjourGem
	include ActiveModel::Validations

	# Attributes
	attr_accessor :link, :twitter, :message
	
	# Validations
	validates_presence_of :link, :twitter
	validates :link, :format => URI::regexp(%w(http https))
	
	def initialize args={}
		args.each do |attr, val|
			instance_variable_set("@#{attr}", val)
		end
	end
end

# Routes
get '/' do
	@error, @confirm = false
	erb :index
end

post "/*" do
	bonjour_gem = BonjourGem.new params['bonjour_gem']
	if bonjour_gem.valid?
		@error   = false
		@confirm = true
		Pony.mail(:to => 'aweaoftheworld@gmail.com', :from => 'bonjourgem@bonjourgem.com', :subject => "Une gem de #{bonjour_gem.twitter}", :body => "Adresse de la gem : #{bonjour_gem.link} \n #{bonjour_gem.message}")
	else
		@error   = true
		@confirm = false
	end
	erb :index
end

# Helpers 
helpers do 
	def today_class
		array_day  = ['dimanche', 'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi']
		day_number = Time.now.strftime("%w").to_i
		return "logo-#{array_day[day_number]}"
	end
end