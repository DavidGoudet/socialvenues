# frozen_string_literal: true

class Fetchers::FetchPlatforms < ApplicationController
  def initialize
    @fetcher_a = FetchWorker.new
    #@fetcher_a = PlatformBFetcher.new
    #@fetcher_a = PlatformCFetcher.new
  end

  def call
    @fetcher_a.perform('Fetchers::PlatformAFetcher')
    #@fetcher_b.perform('PlatformAFetcher')
    #@fetcher_c.perform('PlatformAFetcher')
  end
end
