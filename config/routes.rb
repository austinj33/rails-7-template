Rails.application.routes.draw do
  root 'optimizations#new'
  
  get 'optimizations/new', to: 'optimizations#new'
  post 'optimizations', to: 'optimizations#create'
  get 'optimizations/show', to: 'optimizations#show'
end
