# frozen_string_literal: true

class Fetchers::FetchBulkPlatform < ApplicationController
  def initialize
    @bulk_platform = VenuePlatform.new
  end

  def call
    VenuePlatform.find_each do |venue_platform|
      @bulk_platform.assign_attributes({ 
        name:         venue_platform.name,
        address_1:    venue_platform.address_1,
        address_2:    venue_platform.address_2,
        lat:          venue_platform.lat,
        lng:          venue_platform.lng,
        category_id:  venue_platform.category_id,
        closed:       venue_platform.closed,
        hours:        venue_platform.hours,
        website:      venue_platform.website,
        phone_number: venue_platform.phone_number,
      })
      return @bulk_platform
    end
  end
end