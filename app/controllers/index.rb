before '/new_user' do
  if params[:error] == 'true'
    @error = "No dejes ningún campo vació"
  end
end

get '/' do
  # La siguiente linea hace render de la vista 
  # que esta en app/views/index.erb
  erb :index
end

get '/new_user' do
  # hace render a la vista
  erb :new_user
end

post '/create' do
  # envia peticion creacion de usuario
  @name = params[:name]
  @email = params[:email]
  @password = params[:password]

  es_vacio = User.vacio?(@name, @email, @password)

  unless es_vacio
    # User.create(name: @name, email: @email, password_digest: @password)
    @user = User.new()
    @user.name = params[:name]
    @user.email = params[:email]
    @user.password = params[:password]
    @user.save!
    erb :index
  else 
    redirect to '/new_user?error=true'
  end
end

get '/update' do
  @user = User.find(session[:user_id])
  erb :update_user
end

post '/update' do
  user = User.find(session[:user_id])
  user.name = params[:name]
  user.email = params[:email]
  user.password = params[:password]
  user.save!
  redirect to '/begin_session/:id'
end

get '/delete' do
  user = User.find(session[:user_id])
  user.destroy
  redirect to '/?del=true'
end










# ::::::::::::::SESION::::::::::::::::
before '/' do
  if params[:error] == 'true'
    @error = "No se ha iniciado sesion exitosamente"
  elsif params[:del] == 'true'
    @error = "Usuario eliminado"
  end
end

post '/begin_session' do
  @email = params[:user_crypt]
  @pass = params[:password_crypt]

  

  if User.authenticate(@email, @pass) != nil
    user = User.authenticate(@email, @pass)
    session[:user_id] = user.id
    redirect to "/begin_session/#{session[:user_id]}"
  else
    redirect to '/?error=true'
  end
end

get '/begin_session/:id' do     # muestra un especifico usuario por su id
  @user = User.find(session[:user_id])
  erb :user_session
end

get '/end_session' do
  session[:user_id] = nil
  redirect to '/'
end

get '/return' do
  redirect to "/begin_session/#{session[:user_id]}"
end