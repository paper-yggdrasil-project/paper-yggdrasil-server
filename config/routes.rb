Rails.application.routes.draw do
  root :controller => 'projects', :action => 'index'

  get 'users/index'

  resources :projects

  scope "/:name" do
    get "/" => "projects#show"
  end
end
