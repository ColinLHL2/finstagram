# Handle incoming HTTP request and send HTTP response
get '/' do
  File.read(File.join('app/views', 'index.html'))
end