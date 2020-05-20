# AKWeather - The Assignment
This app shows wheather details for multiple cities and provide 5 days forecast for current city.

# App Design Structure
The app uses VIPER architecture as a design pattern to manage and strcuture code.  App has been divided into Scenes:

1. LandingScene
2. CitiesWeatherScene
3. LocalWeatherScene (VIPER)

# Run Application
To run the application, open AKWeather.xcworkspace file and press "Command" + "R" or select Run from Product menu.

# Run Unit Test
Unit tests have been provided for API Client, and Cities file. Simple press "Command" + "U" or select Test from Product menu to run all the tests.

# Generating Code Coverage Reports
Running unit test using CMD+U button in Xcode, will generate Code Coverage reports into the default derived data directory located at ~/Library/Developer/Xcode/DerivedData and reports generated at Logs/Test directory.

# How to use Application

The application provided two action to user:

1. Check Weather for Multiple Cities
2. Check 5 Days Forecast for current location

1. If user wants to test Weather for Multiple Cities the application presents TextField which accepts comma separated Values.
User can input Min 3 and Max 7 cities at a time.

2. In order to see 5 Days Forecast, simply tap on "5 DAYS FORECAST" and allow the user lcoation when prompt.


# Notes:

The application uses Metric System so all temperature units will be in Celcius(C) and for Wind it will Meter/Second(m/s).
