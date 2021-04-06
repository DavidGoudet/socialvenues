# frozen_string_literal: true

Rails.application.routes.draw do
  resources :venue_platforms, only: [:index, :show, :update]
end
