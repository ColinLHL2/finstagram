# Controller

# Specify our routes/actions

# Handle the GET request for the path '/'
get '/' do
  @finstagram_posts = FinstagramPost.order(created_at: :desc)
  erb(:index)
end

# Handle the GET request for the path '/signup'
get '/signup' do
  @user = User.new
  erb(:signup)
end

# Handle the POST request for the path '/signup'
post '/signup' do
  # handle form data from request body
  email = params[:email]
  avatar_url = params[:avatar_url]
  username = params[:username]
  password = params[:password]

  # instantiate a User
  @user = User.new({
    email: email, 
    avatar_url: avatar_url, 
    username: username, 
    password: password 
  })

  # create a user record
  if @user.save
    "Signed up username: #{@user.username}"
  else
    erb(:signup)
  end
end
