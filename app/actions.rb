helpers do
  # returns a User object or nil
  def current_user
    User.find_by(id: session[:user_id])
  end
end

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
    redirect to('/login')
  else
    erb(:signup)
  end
end

# Handle the GET request for the path '/login'
get '/login' do
  erb(:login)
end

# Handle the POST request for the path '/login'
post '/login' do
  username = params[:username]
  password = params[:password]

  @user = User.find_by(username: username)

  if @user && @user.password == password
    session[:user_id] = @user.id
    redirect to('/')
  else
    @error_message = "Login failed."
    erb(:login)
  end
end

# Handle the GET request for the path '/logout'
get '/logout' do
  session[:user_id] = nil
  redirect to('/')
end

# Handle the GET request for the path '/finstagram_posts/new'
get '/finstagram_posts/new' do
  @finstagram_post = FinstagramPost.new
  erb(:'finstagram_posts/new')
end

# Handle the GET request for the path '/finstagram_posts/:id'
get '/finstagram_posts/:id' do
  @finstagram_post = FinstagramPost.find(params[:id])
  erb(:'finstagram_posts/show')
end

# Handle the POST request for the path '/finstagram_posts'
post '/finstagram_posts' do
  # handle form data from request body
  photo_url = params[:photo_url]

  # instantiate an object
  @finstagram_post = FinstagramPost.new({
    photo_url: photo_url,
    user_id: current_user.id
  })

  if @finstagram_post.save
    redirect to('/')
  else
    erb(:'finstagram_posts/new')
  end
end