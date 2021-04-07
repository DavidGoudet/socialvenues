# frozen_string_literal: true

class MatchHourFormat < ApplicationController
	def initialize(hours_string)
    @hours_string = hours_string
  end

  def call
    return :matches_platform_a if @hours_string =~ /((\d{2}:\d{2})-(\d{2}:\d{2})\|){6}(\d{2}:\d{2})/
    return :matches_platform_b if @hours_string =~ /(\w{3}:(\d{2}:\d{2})-(\d{2}:\d{2})\|){6}(\w{3}:\d{2}:\d{2})/
    return :matches_platform_c if @hours_string =~ /((\d{2}:\d{2})-(\d{2}:\d{2})\,){6}(\d{2}:\d{2})/
    :no_matches
  end

  def convert_a_to_b
    regex= /((\d{2}:\d{2})-(\d{2}:\d{2}))/
    hours_array = @hours_string.scan(regex)
    "Mon:#{hours_array[0][0]}|Tue:#{hours_array[1][0]}|Wed:#{hours_array[1][0]}|Thu:#{hours_array[1][0]}|"\
    "Fri:#{hours_array[1][0]}|Sat:#{hours_array[1][0]}|Sun:#{hours_array[1][0]}"
  end

  def convert_a_to_c
    @hours_string.gsub('|',',')
  end

  def convert_b_to_a
    @hours_string.gsub(/\w{3}:/,'')
  end

  def convert_c_to_a
    @hours_string.gsub(',','|')
  end
end