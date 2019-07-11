# frozen_string_literal: true

Rails.application.routes.draw do
  resources :email, only: [:create]
end
