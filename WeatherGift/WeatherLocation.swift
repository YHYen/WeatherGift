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
}
