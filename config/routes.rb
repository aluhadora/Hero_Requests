HeroRequests::Application.routes.draw do
 
  resources :streams
  resources :heros

  get '/:stream/AddHero/:hero' => 'heros#create'
  get '/:stream/requeststext' => 'heros#herolist'
  get '/:stream/clear' => 'heros#clear'
  get '/:stream' => 'heros#index'

end
