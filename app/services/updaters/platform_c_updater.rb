# frozen_string_literal: true

class Updaters::PlatformCUpdater < ApplicationController
  def initialize(params)
    @params = params
    @url = ENV['base_url_platform_c'] + ENV['api_key']
  end

  def call
    params = transform_params @params
    if params.present?
      params_hash = { venue: params.as_json }
      response = RestClient.patch(@url, params_hash)
      { body: response.body, code: response.code }
    else
      { body: '', code: 400}
    end
  end

  private

  def transform_params(params)
    hours = params['hours'] 
    params['hours'] = transform_hours hours if hours.present?
    return false if hours == :no_matches
    params
  end

  def transform_hours(hours_string)
    matcher = MatchHourFormat.new(hours_string)
    matched = matcher.call
    return hours_string if matched == :matches_platform_c
    return matcher.convert_a_to_c if matched == :matches_platform_a
    return matcher.convert_b_to_c if matched == :matches_platform_b
    matched
  end
end
