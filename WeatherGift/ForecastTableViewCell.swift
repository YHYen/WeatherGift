//
//  ForecastTableViewCell.swift
//  WeatherGift
//
//  Created by 顏逸修 on 2023/4/5.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var forcastImageView: UIImageView!
    @IBOutlet weak var forecastTimeLabel: UILabel!
    @IBOutlet weak var forecastHighLabel: UILabel!
    @IBOutlet weak var forecastLowLabel: UILabel!
    @IBOutlet weak var forecastTextView: UITextView!
    
    var forecastWeather: ForecastWeather! {
        didSet {
            forcastImageView.image = UIImage(named: forecastWeather.forecastIcon)
            forecastTimeLabel.text = forecastWeather.forecastTime
            forecastHighLabel.text = "\(forecastWeather.forecastHigh)°C"
            forecastLowLabel.text = "\(forecastWeather.forecastLow)°C"
            forecastTextView.text = forecastWeather.forecastSummary
        }
    }
}
