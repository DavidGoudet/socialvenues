require 'rails_helper'
require 'webmock/rspec'

describe BulkPlatformController do
	let(:url_a){ 'https://rails-code-challenge.herokuapp.com/platform_a/venue?api_key=0e45bd62dfe7ad39aad2438ccd0d8e69' }
  let(:url_b){ 'https://rails-code-challenge.herokuapp.com/platform_b/venue?api_key=0e45bd62dfe7ad39aad2438ccd0d8e69' }
  let(:url_c){ 'https://rails-code-challenge.herokuapp.com/platform_c/venue?api_key=0e45bd62dfe7ad39aad2438ccd0d8e69' }
  let(:platform_a_response){ '{"id":9,"name":"Bins LLC","address":"2878 Moen Point","lat":"11.7659153664","lng":"86.324760488","category_id":1100,"closed":true,"hours":"10:00-22:00|10:00-22:00|10:00-22:00|10:00-22:00|10:00-22:00|11:00-18:00|11:00-18:00","created_at":"2021-01-28T10:28:59.534Z","updated_at":"2021-04-07T13:26:07.386Z","api_key":"0e45bd62dfe7ad39aad2438ccd0d8e69"}' }
  let(:platform_b_response){ '{"id":9,"name":"Bins LLC","street_address":"2878 Moen Point","lat":"11.7659153664","lng":"86.324760488","category_id":2008,"closed":false,"hours":"Mon:10:00-22:00|Tue:10:00-22:00|Wed:10:00-22:00|Thu:10:00-22:00|Fri:10:00-22:00|Sat:11:00-18:00|Sun:11:00-18:00","created_at":"2021-01-28T10:28:59.539Z","updated_at":"2021-01-28T10:28:59.539Z","api_key":"0e45bd62dfe7ad39aad2438ccd0d8e69"}' }
  let(:platform_c_response){ '{"id":9,"name":"Bins LLC","address_line_1":"2878 Moen Point","address_line_2":"Apt. 568","website":"https://localistico.com","phone_number":"+34666999666","lat":"11.7659153664","lng":"86.324760488","closed":false,"hours":"10:00-22:00,10:00-22:00,10:00-22:00,10:00-22:00,10:00-22:00,11:00-18:00,11:00-18:00","created_at":"2021-01-28T10:28:59.544Z","updated_at":"2021-01-28T10:28:59.544Z","api_key":"0e45bd62dfe7ad39aad2438ccd0d8e69"}' }
  let(:platform_a_updated){ '{"id":9,"name":"New Venue Name","address":"New Address Line","lat":"11.7659153664","lng":"86.324760488","category_id":1100,"closed":true,"hours":"10:00-22:00|10:00-22:00|10:00-22:00|10:00-22:00|10:00-22:00|11:00-18:00|11:00-18:00","created_at":"2021-01-28T10:28:59.534Z","updated_at":"2021-04-07T13:26:07.386Z","api_key":"0e45bd62dfe7ad39aad2438ccd0d8e69"}' }
  let(:platform_b_updated){ '{"id":9,"name":"New Venue Name","address":"New Address Line","lat":"11.7659153664","lng":"86.324760488","category_id":1100,"closed":true,"hours":"10:00-22:00|10:00-22:00|10:00-22:00|10:00-22:00|10:00-22:00|11:00-18:00|11:00-18:00","created_at":"2021-01-28T10:28:59.534Z","updated_at":"2021-04-07T13:26:07.386Z","api_key":"0e45bd62dfe7ad39aad2438ccd0d8e69"}' }
  let(:platform_c_updated){ '{"id":9,"name":"New Venue Name","address":"New Address Line","lat":"11.7659153664","lng":"86.324760488","category_id":1100,"closed":true,"hours":"10:00-22:00|10:00-22:00|10:00-22:00|10:00-22:00|10:00-22:00|11:00-18:00|11:00-18:00","created_at":"2021-01-28T10:28:59.534Z","updated_at":"2021-04-07T13:26:07.386Z","api_key":"0e45bd62dfe7ad39aad2438ccd0d8e69"}' }
  let(:generic_hours_type_b){ 'Mon:10:00-22:00|Tue:10:00-22:00|Wed:10:00-22:00|Thu:10:00-22:00|Fri:10:00-22:00|Sat:11:00-18:00|Sun:11:00-18:00' }

  describe "GET :index" do
    context 'with valid response from the server' do
      it 'returns the merged venue' do
        stub_request(:get, url_a).to_return(status: 200, body: platform_a_response, headers: {})
        stub_request(:get, url_b).to_return(status: 200, body: platform_b_response, headers: {})
        stub_request(:get, url_c).to_return(status: 200, body: platform_c_response, headers: {})
        get :index
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)["website"]).to eq "https://localistico.com"
        expect(JSON.parse(response.body)["category_id"]).to eq 1100
      end
    end
  end

  describe "PATCH bulk_platform/:id" do
    context 'with valid parameters' do
      it 'updates all the venues' do
        stub_request(:get, url_a).to_return(status: 200, body: platform_a_response, headers: {})
        stub_request(:get, url_b).to_return(status: 200, body: platform_b_response, headers: {})
        stub_request(:get, url_c).to_return(status: 200, body: platform_c_response, headers: {})
        stub_request(:patch, url_a).to_return(status: 200, body: platform_a_updated, headers: {})
        stub_request(:patch, url_b).to_return(status: 200, body: platform_b_updated, headers: {})
        stub_request(:patch, url_c).to_return(status: 200, body: platform_c_updated, headers: {})
        get :index
        patch :update, params: { id: VenuePlatform.first.id, name: "New Venue Name", address_line_1:"New Address Line", hours: generic_hours_type_b }
        expect(response.status).to eq 200
        expect(response.body).to eq "Venues Updated"
      end
    end
  end
end
