# frozen_string_literal: true

class Fetchers::FetchBulkPlatform < ApplicationController
  def initialize
    @bulk_platform = VenuePlatform.new
  end

  def call
    params = {
      name:         nil,
      address_1:    nil,
      address_2:    nil,
      lat:          nil,
      lng:          nil,
      category_id:  nil,
      closed:       nil,
      hours:        nil,
      website:      nil,
      phone_number: nil,
    }
    params = populate_params params
    assign_values params

    return @bulk_platform
  end

  private

  def populate_params(params)
    VenuePlatform.find_each do |venue_platform|
      params[:name] ||= venue_platform.name
      params[:address_1] ||= venue_platform.address_1
      params[:address_2] ||= venue_platform.address_2
      params[:lat] ||= venue_platform.lat
      params[:lng] ||= venue_platform.lng
      params[:category_id] ||= venue_platform.category_id
      params[:closed] ||= venue_platform.closed
      params[:hours] ||= venue_platform.hours
      params[:website] ||= venue_platform.website
      params[:phone_number] ||= venue_platform.phone_number 
    end
    return params
  end

  def assign_values(params)
    @bulk_platform.assign_attributes({ 
        name:         params[:name],
        address_1:    params[:address_1],
        address_2:    params[:address_2],
        lat:          params[:lat],
        lng:          params[:lng],
        category_id:  params[:category_id],
        closed:       params[:closed],
        hours:        params[:hours],
        website:      params[:website],
        phone_number: params[:phone_number],
      })
  end
end