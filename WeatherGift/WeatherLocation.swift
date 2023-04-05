//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by 顏逸修 on 2023/4/4.
//

import Foundation


class WeatherLocation: Codable {
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
    func getData() {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(APIkeys.openWeatherKey)&units=metric"
        
        print("🕸️ We are accessing the url \(urlString)")
        
        // create a URL datatype
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Couldn't create a url from \(urlString)")
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
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("😎 \(json)")
            } catch {
                print("😡 ERROR: JSON ERROR \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
