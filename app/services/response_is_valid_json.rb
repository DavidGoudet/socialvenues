# frozen_string_literal: true

class ResponseIsValidJson < ApplicationController
  def initialize(response)
    @response = response
  end

  def call
    begin
      JSON.parse(@response)
    rescue
      false
    end
  end
end