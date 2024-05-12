helpers do
  # returns a User object or nil
  def current_user
    User.find_by(id: session[:user_id])
  end

  # returns a boolean
  def logged_in?
    !!current_user
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

# before block
before '/finstagram_posts/new' do
  redirect to('/login') unless logged_in?
end

# Handle the GET request for the path '/finstagram_posts/new'
get '/finstagram_posts/new' do
  @finstagram_post = FinstagramPost.new
  erb(:'finstagram_posts/new')
end

# Handle the GET request for the path '/finstagram_posts/:id'
get '/finstagram_posts/:id' do
  @finstagram_post = FinstagramPost.find_by(id: params[:id])

  if @finstagram_post
    erb(:'finstagram_posts/show')
  else
    halt(404, erb(:'errors/404'))
  end
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

# Handle the POST request for the path '/comments'
post '/comments' do
  # point values from params to variables
  text = params[:text]
  finstagram_post_id = params[:finstagram_post_id]

  # instantiate a comment with those values & assign the comment to the `current_user`
  comment = Comment.new({ text: text, finstagram_post_id: finstagram_post_id, user_id: current_user.id })

  # save the comment
  comment.save

  # `redirect` back to wherever we came from
  redirect(back)
end

# Handle the POST request for the path '/likes'
post '/likes' do
  finstagram_post_id = params[:finstagram_post_id]

  like = Like.new({ finstagram_post_id: finstagram_post_id, user_id: current_user.id })
        
  like.save

  redirect(back)
end

# Handle the DELETE request for the path '/likes/:id'
delete '/likes/:id' do
  like = Like.find(params[:id])
  like.destroy
  redirect(back)
end

# before block
before '/profile' do
  redirect to('/login') unless logged_in?
end

get '/profile' do
  erb(:profile)
end