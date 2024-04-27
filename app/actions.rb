# Handle incoming HTTP request and send HTTP response
get '/' do
  # get FPosts from database (array of object)
  @finstagram_posts = FinstagramPost.order(created_at: :desc)  
  # use Sinatra erb method to use a View file
  erb(:index)
end


