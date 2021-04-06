# frozen_string_literal: true

class FetchPlatforms < ApplicationController
  def initialize
    @fetcher_a = PlatformAFetcher.new
  end

  def call
    @fetcher_a.call
  end
end
