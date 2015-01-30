require 'sinatra'
require './rolodex'
require 'data_mapper'

DataMapper.setup(:default, "sqlite3:database.sqlite3")

class Contact
	include DataMapper::Resource

	property :id, Serial # Serial is an auto-integer that auto-increments
	property :first_name, String
	property :last_name, String
	property :email, String
	property :note, String

	# attr_accessor :id, :first_name, :last_name, :email, :note

	# def initialize(first_name, last_name, email, note)
	# 	@first_name = first_name
	# 	@last_name = last_name
	# 	@note = note
	# 	@email = email
	# end
end

DataMapper.finalize
DataMapper.auto_upgrade! # Checks to see if there are any changes in your code before you upgrade


# end of datamapper setup



# begin sinatra routes


get '/' do 
	@crm_name = "Wes Landriault's CRM"
	@title= "Wes Landriault's CRM"
	erb :index

end


get '/contacts' do
	@contacts = Contact.all
	@title = 'Contacts'
	erb :contacts
end

get '/contacts/new' do
	@title = "Add a New Contact"	
	erb :new
end

get '/contacts/:id' do
	# @contact = @@rolodex.find(params[:id].to_i)
	@contact = Contact.get(params[:id].to_i)
	if @contact
		erb :show_contact
	else
		raise Sinatra::NotFound
	end
end

post '/contacts' do
	new_contact = Contact.new(params)
	new_contact.save
	# @@rolodex.add_contact(contact)
	redirect to('/contacts')
	# puts params
end

get '/contacts/:id/edit' do
	@contact = Contact.get(params[:id].to_i)
	
	if @contact
		erb :edit_contact
	else
		raise Sinatra::NotFound
	end

end

put "/contacts/:id" do
	@contact = Contact.get(params[:id].to_i)

	if @contact
		@contact.first_name = params[:first_name]
		@contact.last_name = params[:last_name]
		@contact.email = params[:email]
		@contact.note = params[:note]

		redirect to("/contacts")

	else
		raise Sinatra::NotFound
	end
end

delete "/contacts/:id" do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    # @@rolodex.remove_contact(@contact)
    @contact.destroy
    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end



