//
//  WeatherResult.swift
//  WeatherHW
//
//  Created by Нургазы on 23/1/21.
//

import Foundation

struct WeatherResult: Codable {
    let weather: [Weather]
    let visibility: Double
    let wind: Wind
    let main: Main
    let clouds: Clouds
    let name: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Double
}

struct Clouds: Codable {
    let all: Double
}



/*
 
 {
 
 HTTPS request -> Server, Server -> JSON -> Object (Class, Struct) (Decoding)
 
 
 -  "coord": {
     "lon": 74.59,
     "lat": 42.87
   },
 +  "weather": [
     {
       "id": 804,
       "main": "Clouds",
       "description": "overcast clouds",
       "icon": "04n"
     }
   ],
 -  "base": "stations",
 +  "main": {
     "temp": -7,
     "feels_like": -14.39,
     "temp_min": -7,
     "temp_max": -7,
     "pressure": 1029,
     "humidity": 68
   },
 +  "visibility": 7000,
 +  "wind": {
     "speed": 6,
     "deg": 60
   },
 +  "clouds": {
     "all": 100
   },
 -  "dt": 1611415604,
 -  "sys": {
     "type": 1,
     "id": 8871,
     "country": "KG",
     "sunrise": 1611368684,
     "sunset": 1611403311
   },
 -  "timezone": 21600,
 -  "id": 1528675,
 +  "name": "Bishkek",
 -  "cod": 200
 }
 
 */
