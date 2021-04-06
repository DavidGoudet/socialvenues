# frozen_string_literal: true

class Updaters::PlatformAUpdater < ApplicationController
  def initialize(params)
    @params = params
    @url = ENV['base_url_platform_a'] + ENV['api_key']
  end

  def call
    response=RestClient.patch(@url, @params).execute do |response_api, request, result|
      pp response_api
    end
    
  end
end
