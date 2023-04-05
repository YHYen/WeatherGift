//
//  WeatherDetail.swift
//  WeatherGift
//
//  Created by 顏逸修 on 2023/4/5.
//

import Foundation


private var dateFormatter: DateFormatter = {
    print("📆📆📆 I JUST CREATE A DATE FORMATTER in WeatherDetail.swift!")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE h aaa"
    return dateFormatter
}()


private var dateFormatterForNavbar: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "ha"
    return dateFormatter
}()


struct ForecastWeather {
    var forecastIcon: String
    var forecastTime: String
    var forecastSummary: String
    var forecastHigh: Int
    var forecastLow: Int
    var navbarTime: String
    var hourlyTemp: Int
    var hourlyIcon: String
}


class WeatherDetail: WeatherLocation {
    
    // TODO: change Integer timezone to string timezone
    private struct Result: Codable {
        var timezone: Int
        var dt: TimeInterval
        var main: Main
        var weather: [Weather]

    }
    
    private struct ForecastResult: Codable {
        var city: City
        var list: [List]
    }
    
    private struct Main: Codable {
        var temp: Double
        var temp_min: Double
        var temp_max: Double
    }
    
    private struct Weather: Codable {
        var description: String
        var icon: String
        var id: Int
    }
    
    private struct City: Codable {
        var timezone: Int
    }
    
    private struct List: Codable {
        var dt: TimeInterval
        var main: Main
        var weather: [Weather]
    }
    
    var timeZone = 0
    var currentTime = 0.0
    var temperature = 0
    var summary = ""
    var dailyIcon = ""
    var forecastWeatherData: [ForecastWeather] = []
    
    
    func getCurrentData(completed: @escaping () -> () ) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(APIkeys.openWeatherKey)&units=metric"
        
        // print("🕸️ We are accessing the url \(urlString)")
        
        // create a URL datatype
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Couldn't create a url from \(urlString)")
            completed()
            return
        }
        
        // create Session
        let session = URLSession.shared
        
        // get data with .dataTask method
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("😡 ERROR: \(error.localizedDescription)")
            }
            
            // note: there are some additional things that could go wrong using URLSession, but we shouldn't experience them, so we're ignore test for these for now...
            
            // deal with the data
            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                let result = try JSONDecoder().decode(Result.self, from: data!)
//                print("😎 \(result)")
//                print("The timezone for \(self.name) : \(result.timezone)")
                self.timeZone = result.timezone
                self.currentTime = result.dt
                self.temperature = Int(result.main.temp.rounded())
                self.summary = result.weather[0].description
                self.dailyIcon = self.fileNameForIcon(icon: result.weather[0].icon)
                
            } catch {
                print("😡 ERROR: JSON ERROR \(error.localizedDescription)")
            }
            completed()
        }
        
        task.resume()
    }
    
    
    func getForecastData(completed: @escaping () -> () ) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(APIkeys.openWeatherKey)&units=metric"

        print("🕸️ We are accessing the url \(urlString)")

        // create a URL datatype
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Couldn't create a url from \(urlString)")
            completed()
            return
        }

        // create Session
        let session = URLSession.shared

        // get data with .dataTask method
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("😡 ERROR: \(error.localizedDescription)")
            }

            // note: there are some additional things that could go wrong using URLSession, but we shouldn't experience them, so we're ignore test for these for now...

            // deal with the data
            do {
                let forecastResult = try JSONDecoder().decode(ForecastResult.self, from: data!)
                
                
                // limit the data length
                let lastData = min(20, forecastResult.list.count)
                
                if lastData > 0 {
                    // use loop to get data of differrent time from json
                    for index in 1...lastData {
                        
                        // set forecast weather data
                        let forecastIcon = self.fileNameForIcon(icon:(forecastResult.list[index].weather[0].icon))
                        let forecastSummary = forecastResult.list[index].weather[0].description
                        let forecastHigh = Int(forecastResult.list[index].main.temp_max.rounded())
                        let forecastLow = Int(forecastResult.list[index].main.temp_min.rounded())
                        
                        // use dateFormatter to change date display state
                        let time = Date(timeIntervalSince1970: forecastResult.list[index].dt)
                        dateFormatter.timeZone = TimeZone(secondsFromGMT: forecastResult.city.timezone)
                        let forecastTime = dateFormatter.string(from: time)
                        
                        // use dateFormatterForNavbar to change date display state for navbar
                        dateFormatterForNavbar.timeZone = TimeZone(secondsFromGMT: forecastResult.city.timezone)
                        let navbarTime = dateFormatterForNavbar.string(from: time)
                        
                        // set forecastTemp
                        let hourlyTemp = Int(forecastResult.list[index].main.temp.rounded())
                        
                        // set hourly icon
                        let hourlyIcon = self.systemNameFromId(id: (forecastResult.list[index].weather[0].id), icon: (forecastResult.list[index].weather[0].icon))
                        
                        let forecastWeather = ForecastWeather(forecastIcon: forecastIcon, forecastTime: forecastTime, forecastSummary: forecastSummary, forecastHigh: forecastHigh, forecastLow: forecastLow, navbarTime: navbarTime, hourlyTemp: hourlyTemp, hourlyIcon: hourlyIcon)
                        self.forecastWeatherData.append(forecastWeather)
                        print("Time: \(forecastTime), High: \(forecastHigh), Low: \(forecastLow)")
                    }
                }
                


            } catch {
                print("😡 ERROR: JSON ERROR in forecast \(error.localizedDescription)")
            }
            completed()
        }

        task.resume()
    }
    
    
    private func fileNameForIcon(icon: String) -> String {
        var fileName = ""
        switch icon {
        case "01d":
            fileName = "clear-day"
        case "01n":
            fileName = "clear-night"
        case "02d":
            fileName = "partly-cloudy-day"
        case "02n":
            fileName = "partly-cloudy-night"
        case "03d", "03n", "04d", "04n":
            fileName = "cloudy"
        case "09d", "09n", "10d", "10n":
            fileName = "rain"
        case "11d", "11n":
            fileName = "thunderstorm"
        case "13d", "13n":
            fileName = "snow"
        case "50d", "50n":
            fileName = "fog"
        default:
            fileName = "ERROR"
        }
        
        return fileName
    }
    
    
    private func systemNameFromId(id: Int, icon: String) -> String {
        switch id {
        case 200...299:
            return "cloud.bolt.rain"
        case 300...399:
            return "cloud.drizzle"
        case 500, 501, 520, 521, 531:
            return "cloud.rain"
        case 502, 503, 504, 522:
            return "cloud.heavyrain"
        case 511, 611...616:
            return "sleet"
        case 600...602, 620...622:
            return "snow"
        case 701, 711, 741:
            return "fog"
        case 721:
            return (icon.hasSuffix("d") ? "sun.haze" : "cloud.fog")
        case 731, 751, 761, 762:
            return (icon.hasSuffix("d") ? "sun.dust" : "cloud.fog")
        case 771:
            return "wind"
        case 781:
            return "tornado"
        case 800:
            return (icon.hasSuffix("d") ? "sun.max" : "moon")
        case 801, 802:
            return (icon.hasSuffix("d") ? "cloud.sun" : "cloud.moon")
        case 803, 804:
            return "cloud"
        default:
            return "questionmark.diamond"
        }
    }
}
