# frozen_string_literal: true

class PlatformAFetcher < ApplicationController
  def initialize
    @platform = VenuePlatform.find_or_create_by(platform_name: :platform_a)
    @url = ENV['base_url_platform_a']+ENV['api_key']
  end

  def call
    response = RestClient.get(@url)
    platform_hash = JSON.parse(response)
    save_information platform_hash
  end

  def save_information(platform_hash)
    @platform.update(address_1: platform_hash[:address])    
  end
end
