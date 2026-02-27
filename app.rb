
require 'sinatra'
require 'json'
require 'httparty'


set :bind, '0.0.0.0'
set :port, ENV.fetch("PORT", 4567)

mensagens = []

# Página inicial
get '/' do
  erb :index
end

# Chat Online
get '/chat_online' do
  erb :chat_online
end

post '/enviar' do
  mensagens << params[:mensagem]
  redirect '/chat_online'
end

get '/mensagens' do
  content_type :json
  mensagens.to_json
end

# Chat IA
get '/chat_ia' do
  erb :chat_ia
end

post '/mensagem_ia' do
  mensagem = params[:mensagem]

  response = HTTParty.post(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=AIzaSyCR3HRyajkMxZQp02mqgtKau469VizPH60",
    headers: {
      "Content-Type" => "application/json"
    },
    body: {
      contents: [
        {
          parts: [
            { text: mensagem }
          ]
        }
      ]
    }.to_json
  )

  data = response.parsed_response

  if data["candidates"]
    data["candidates"][0]["content"]["parts"][0]["text"]
  else
    "Erro: #{data}"
  end
end