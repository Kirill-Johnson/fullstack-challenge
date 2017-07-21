Rails.application.routes.draw do

  resources :trip_stops, except: [:new, :edit]
  get 'authn/whoami', defaults: {format: :json}
  get 'authn/checkme'

  mount_devise_token_auth_for 'User', at: 'auth'

  scope :api, defaults: {format: :json}  do 
    resources :images, except: [:new, :edit] do
    end

    get "images/:id/content", as: :image_content, controller: :images, action: :content, defaults:{format: :jpg}
  end      

  get "/client-assets/:name.:format", :to => redirect("/client/client-assets/%{name}.%{format}")

  get '/ui'  => 'ui#index'
  get '/ui#' => 'ui#index'
  root "ui#index"
end
