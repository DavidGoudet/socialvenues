# Venues Social Media Management API

This app uses Ruby on Rails to fetch, update and bulk update venues information on social media platforms.
Requirements:
```
Ruby 3.0.0
Ruby on Rails 6.1.3
PostgreSQL
```

## Installation
This application is designed to be run locally with Ruby on Rails and a PostgreSQL database.
You have to start by installing the Requirements. You can use RVM to manage the Ruby versions and activate the environment.
To install the Gems go to the root of the project and run:
```
bundle install
```
To configure the database:
```
rails db:create
rails db:migrate
```

## Starting the Server
Run this command in the root of the project:
```
rails server
```
This app uses **Sidekiq** to manage the execution of asynchronic processes, to run the Sidekiq server you need to open a new terminal and switch to the required Ruby version. Then you need to run:
```
bundle exec sidekiq
```

You can use Postman to test the Endpoints.
## Endpoints
*GET /*  
*GET /venue_platforms*  
The root of the app will render a JSON response with the venue's social media platforms that are stored in the system.

*GET /venue_platforms/id*  
This endpoint will render a specific venue social media platform.

*PATCH /venue_platforms/id*  
This endpoint will update the venue platform both in local and in the external social media API. The parameters will be specified bellow.

*GET /bulk_platform*  
This endpoint will show a consolidated venue, product of the merge of all of the available platforms.

*PATCH /bulk_platform*  
This endpoint will allow to update all the information in all of the platforms at the same time.

## Parameters
name, address_line_1, address_line_2, lat, lng, closed, hours, website, phone_number, category_id

Those are the recommended parameters, but in the case a platform has a different name for a field, the app will convert the field to the standard name.

For example:
Platform A uses "address" while Platform C uses "address_line_1". While updating the Platform A you could use "address" with the PATCH and the app will accept the parameter and save it to the standard name.

## Controllers
Both controllers use just methods that are part of the CRUD. This is following a pattern suggested by David Heinemeier Hansson, the creator of Ruby on Rails.

The **VenuePlatformsController** is controlling the visualization and update of the venue in the different social media platforms on a individual basis. Before the Read actions is running a method that's fetching from all of the APIs and saving to the database.
The **BulkPlatformController** is similar to the VenuePlatformsController but it works for bulk actions, both for the Read and Update actions.

## Models
The **VenuePlatform** is a simple model that allows the storing of the information available in the social media platforms.

## Services
The services were created to extract complex methods and to allow the Controllers to have reusable code.
* Fetchers  
The Fetchers are mainly controlled by **Fetchers::FetchPlatforms**, a service that iterates on the VenuePlatforms and calls the appropiate fetcher manager for every social media platform. To call the specific fetcher it calls a Sidekiq Worker called **FetchWorker** and it constantizes the names of the platforms to run the specific manager: **PlatformXFetcher**.
The latter service is customized to manage and connect with every platform, validating its information and saving it.
* Updaters  
The updaters are doing a similar job, but this time transforming the information before sending it to the platforms APIs. These make possible to use custom or standard parameters.
* MatchHourFormat  
This service is pattern matching the hours format to validate the input. It also converts to other formats to serve the BulkUpdater. The app is capable of converting the hours formats to save the right one on every platform.
* ResponseIsValidJSON  
This is a simple service to check if the platforms are responding with valid JSON.

## Workers
The app is using Sidekiq workers to process the fetching and updating asynchronically. This could be useful in the future to recover the app if one of the many platforms's apis are not responding.

#Testing
The app is using the gem **Rspec** to test the API and **WebMock** to create stubs to simulate the API calls to the platforms. Both set of tests are testing the API against good and bad requests in both controllers.
To run them you just need to call:
```
rspec
```
