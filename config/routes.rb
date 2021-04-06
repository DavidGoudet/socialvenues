# frozen_string_literal: true

Rails.application.routes.draw do
  root "venue_platforms#index"

  resources :venue_platforms, only: [:index, :show, :update] do 
  	collection do
  		patch :bulk_update
  	end
  end
end
