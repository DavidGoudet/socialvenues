# frozen_string_literal: true

class Updaters::PlatformAUpdater < ApplicationController
  def initialize(params)
    @params = params
    @url = ENV['base_url_platform_a'] + ENV['api_key']
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

    params = transform_address params

    return false if !check_category_id(params) || hours == :no_matches
    params
  end

  def transform_hours(hours_string)
    matcher = MatchHourFormat.new(hours_string)
    matched = matcher.call
    return hours_string if matched == :matches_platform_a
    return matcher.convert_b_to_a if matched == :matches_platform_b
    return matcher.convert_c_to_a if matched == :matches_platform_c
    matched
  end

  def transform_address(params)
    address_bulk = params['address_line_1']
    address_specific = params['address']

    params['address_1'] = address_bulk if address_bulk.present?
    params['address_1'] = address_specific if address_specific.present?
    params
  end

  def check_category_id(params)
    return true unless params['category_id'].present?

    cat_id = params['category_id'].to_i
    cat_id > 1000 && cat_id < 1200
  end
end
