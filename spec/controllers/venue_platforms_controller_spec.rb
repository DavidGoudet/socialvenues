require 'rails_helper'
require 'webmock/rspec'

describe VenuePlatformsController do
  let(:url_a){ 'https://rails-code-challenge.herokuapp.com/platform_a/venue?api_key=0e45bd62dfe7ad39aad2438ccd0d8e69' }
  let(:url_b){ 'https://rails-code-challenge.herokuapp.com/platform_b/venue?api_key=0e45bd62dfe7ad39aad2438ccd0d8e69' }
  let(:url_c){ 'https://rails-code-challenge.herokuapp.com/platform_c/venue?api_key=0e45bd62dfe7ad39aad2438ccd0d8e69' }
  let(:platform_a_response){ '{"id":9,"name":"Bins LLC","address":"2878 Moen Point","lat":"11.7659153664","lng":"86.324760488","category_id":1100,"closed":true,"hours":"10:00-22:00|10:00-22:00|10:00-22:00|10:00-22:00|10:00-22:00|11:00-18:00|11:00-18:00","created_at":"2021-01-28T10:28:59.534Z","updated_at":"2021-04-07T13:26:07.386Z","api_key":"0e45bd62dfe7ad39aad2438ccd0d8e69"}' }
  let(:platform_b_response){ '{"id":9,"name":"Bins LLC","street_address":"2878 Moen Point","lat":"11.7659153664","lng":"86.324760488","category_id":2008,"closed":false,"hours":"Mon:10:00-22:00|Tue:10:00-22:00|Wed:10:00-22:00|Thu:10:00-22:00|Fri:10:00-22:00|Sat:11:00-18:00|Sun:11:00-18:00","created_at":"2021-01-28T10:28:59.539Z","updated_at":"2021-01-28T10:28:59.539Z","api_key":"0e45bd62dfe7ad39aad2438ccd0d8e69"}' }
  let(:platform_c_response){ '{"id":9,"name":"Bins LLC","address_line_1":"2878 Moen Point","address_line_2":"Apt. 568","website":"https://localistico.com","phone_number":"+34666999666","lat":"11.7659153664","lng":"86.324760488","closed":false,"hours":"10:00-22:00,10:00-22:00,10:00-22:00,10:00-22:00,10:00-22:00,11:00-18:00,11:00-18:00","created_at":"2021-01-28T10:28:59.544Z","updated_at":"2021-01-28T10:28:59.544Z","api_key":"0e45bd62dfe7ad39aad2438ccd0d8e69"}' }
  let(:platform_a_response_off_limits){ '{"id":9,"name":"Bins LLC","address":"2878 Moen Point","lat":"11.7659153664","lng":"86.324760488","category_id":6000,"closed":true,"hours":"10:00-22:00|10:00-22:00|10:00-22:00|10:00-22:00|10:00-22:00|11:00-18:00|11:00-18:00","created_at":"2021-01-28T10:28:59.534Z","updated_at":"2021-04-07T13:26:07.386Z","api_key":"0e45bd62dfe7ad39aad2438ccd0d8e69"}' }
  let(:platform_a_name_updated){ '{"id":9,"name":"New Venue Name","address":"2878 Moen Point","lat":"11.7659153664","lng":"86.324760488","category_id":1100,"closed":true,"hours":"10:00-22:00|10:00-22:00|10:00-22:00|10:00-22:00|10:00-22:00|11:00-18:00|11:00-18:00","created_at":"2021-01-28T10:28:59.534Z","updated_at":"2021-04-07T13:26:07.386Z","api_key":"0e45bd62dfe7ad39aad2438ccd0d8e69"}' }
  describe "GET :index" do
    context 'with valid response from the server' do
      it 'returns the current venue platforms' do
        stub_request(:get, url_a).to_return(status: 200, body: platform_a_response, headers: {})
        stub_request(:get, url_b).to_return(status: 200, body: platform_b_response, headers: {})
        stub_request(:get, url_c).to_return(status: 200, body: platform_c_response, headers: {})
        get :index
        expect(response.status).to eq 200
        expect(response.body).to eq VenuePlatform.all.to_json
      end
    end

    context 'with invalid json response from the server' do
      it 'returns error message' do
        stub_request(:get, url_a).to_return(status: 200, body: "", headers: {})
        get :index
        expect(response.status).to eq 400
        expect(response.body).to eq "Error saving. The information we fetched is not valid."
      end
    end

    context 'with invalid limits for category_id coming from the server' do
      it 'returns error message' do
        stub_request(:get, url_a).to_return(status: 200, body: platform_a_response_off_limits, headers: {})
        get :index
        expect(response.status).to eq 400
        expect(response.body).to eq "Error saving. The information we fetched is not valid."
      end
    end
  end

  describe "GET venue_platform/:id" do
    context 'with valid response from the server' do
      it 'returns the current venue platform' do
        stub_request(:get, url_a).to_return(status: 200, body: platform_a_response, headers: {})
        stub_request(:get, url_b).to_return(status: 200, body: platform_b_response, headers: {})
        stub_request(:get, url_c).to_return(status: 200, body: platform_c_response, headers: {})
        get :index
        get :show, params: { id: VenuePlatform.first.id }
        expect(response.status).to eq 200
        expect(response.body).to eq VenuePlatform.first.to_json
      end
    end

    context 'with invalid id' do
      it 'returns an error message' do
        stub_request(:get, url_a).to_return(status: 200, body: platform_a_response, headers: {})
        stub_request(:get, url_b).to_return(status: 200, body: platform_b_response, headers: {})
        stub_request(:get, url_c).to_return(status: 200, body: platform_c_response, headers: {})
        get :index
        get :show, params: { id: -1 }
        expect(response.status).to eq 404
        expect(response.body).to eq "The VenuePlatform with id -1 was not found"
      end
    end
  end

  describe "PATCH venue_platform/:id" do
    context 'with valid parameters' do
      it 'updates the venue platform' do
        stub_request(:get, url_a).to_return(status: 200, body: platform_a_response, headers: {})
        stub_request(:get, url_b).to_return(status: 200, body: platform_b_response, headers: {})
        stub_request(:get, url_c).to_return(status: 200, body: platform_c_response, headers: {})
        stub_request(:patch, url_a).to_return(status: 200, body: platform_a_name_updated, headers: {})
        get :index
        patch :update, params: { id: VenuePlatform.first.id, name: "New Venue Name" }
        expect(response.status).to eq 200
        response_name = JSON.parse(response.body)["name"]
        expect(response_name).to eq "New Venue Name"
      end
    end

    context 'with invalid parameters' do
      it 'returns bad request error code' do
        stub_request(:get, url_a).to_return(status: 200, body: platform_a_response, headers: {})
        stub_request(:get, url_b).to_return(status: 200, body: platform_b_response, headers: {})
        stub_request(:get, url_c).to_return(status: 200, body: platform_c_response, headers: {})
        stub_request(:patch, url_a).to_return(status: 200, body: platform_a_name_updated, headers: {})
        get :index
        patch :update, params: { id: VenuePlatform.first.id, category_id: 60000 }
        expect(response.status).to eq 400
      end
    end
  end
end
