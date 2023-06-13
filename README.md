# <b>Whether Sweater</b>
## <i>Or, Sweater Weather</i>

Whether Sweater was designed as part of Turing School of Software and Design's Back-End program, as our Module 3 Final Solo Project.

# What Is It?
Whether Sweater is the back-end portion of an app that allows users to plan road trips, and see the potential weather at their destination.
The app aggregates information from two different APIs, and presents a collection of information including the trip's origin, the trip's destination, travel time, and a brief overview of the weather AT the destination, AT the time of arrival.<br>

It also provides systems to create an account with the front-end website, and a login function. These can be emulated in Postman by sending POST requests to the endpoints I will discuss later in this readme.

## Technical Details
Whether Sweater is a Ruby on Rails API-only app. Some of the technologies used in development are as follows:
<b>Ruby on Rails</b> - This app was built with Ruby on Rails
<b>PostgreSQL</b> - This app uses a PostgreSQL database to store user login information.
<b>RSpec</b> - All testing was done using RSpec, with a 100% coverage rate when checked with the SimpleCov gem.
<b>WebMock</b> - So as to not run up API calls, in testing, web connections are disabled and are replaced with stubbed "fixture" files - these are essentialy just copies of an actual response, saved in a JSON file to be accessed by WebMock and served up as a "response" from the API call.

## Setting Up
In order to run the Whether Sweater API locally, you will need to first clone and set up the repository. Once you've got it cloned, you'll run the following:
```
bundle install
rails db:{create,migrate}
```
It's that simple! ...just kidding, there are a few more steps before we can start making API calls. The first thing you'll need is an API key from MapQuest. You can do that [here](https://developer.mapquest.com/user/login/sign-up).<br>
The next thing you'll need is an API key from weatherapi. You can sign up for free [here](https://www.weatherapi.com/signup.aspx).<br>
Once you've got those keys, you can use the [figaro gem](https://github.com/laserlemon/figaro) to create and store your environment variables, and call them as needed.<br>

Now that we've got everything set up, you're ready to start making API calls! You can start your rails server by running 
```
rails s
```
Once you've got that up and running, feel free to try out the different routes. At the time of this readme, there are a total of 4 endpoints exposed. I will briefly discuss each of them in...

## Endpoints
# Forecast Endpoint
Example Request: `GET /api/v1/forecast?location=:location`<br>
Example Response:
```
{
    "data": {
        "id": null,
        "type": "forecast",
        "attributes": {
            "current_weather": {
                "last_updated": "2023-06-13 16:15",
                "temperature": 93.2,
                "feels_like": 103.2,
                "humidity": 56,
                "uvi": 9.0,
                "visibility": 4.0,
                "condition": "Mist",
                "icon": "//cdn.weatherapi.com/weather/64x64/day/143.png"
            },
            "daily_weather": [
                {
                    "date": "2023-06-13",
                    "sunrise": "06:33 AM",
                    "sunset": "08:27 PM",
                    "max_temp": 95.7,
                    "min_temp": 79.3,
                    "condition": "Sunny",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png"
                },
```
# User Registration Endpoint
example request: `POST /api/v1/users`
```
Content-Type: application/json
Accept: application/json
{
  "user": {
    "email": "carsarecool@example.com"
    "password": "password1"
    "password_confirmation": "password1"
    }
}
```
![Screenshot 2023-06-13 at 3 59 15 PM](https://github.com/brenicillin/whether_sweater/assets/120131327/431e5f25-7de9-4529-b9e0-e39edcd34f14)

# Login Endpoint
Example request: `POST /api/v1/sessions'
```
Content-Type: application/json
Accept: application/json
{
  "user": {
    "email": "carsarecool@example.com"
    "password": "password1"
    }
}
```
![Screenshot 2023-06-13 at 3 59 49 PM](https://github.com/brenicillin/whether_sweater/assets/120131327/59e87d1a-33f4-45f2-a595-a96cac17efa6)

# Create Road Trip
Example request: `POST api/v1/road_trip`
```
Content-Type: application/json
Accept: application/json
{
  "origin": "Tampa,FL"
  "destination": "Raleigh,NC"
  "api_key": "api_key_recieved_at_reg/login"
}
```
![Screenshot 2023-06-13 at 4 00 16 PM](https://github.com/brenicillin/whether_sweater/assets/120131327/0ee1812d-4d2d-4759-ba04-bae276491d7e)

# Database
There is only one table used by this app, and that is the Users table. Outside of storing user data, this app exclusively aggregates data from outside APIs and exposes endpoints that allow that data to be consumed.
```
create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
  ```
# Contributors
Brandon Johnson<br>
[LinkedIn](www.linkedin.com/in/brandon-j-94b740b2)
