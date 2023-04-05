//
//  ForecastCollectionViewCell.swift
//  WeatherGift
//
//  Created by 顏逸修 on 2023/4/5.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var hourlyLabel: UILabel!
    @IBOutlet weak var hourlyTemperature: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var forecastWeather: ForecastWeather! {
        didSet {
            hourlyLabel.text = forecastWeather.navbarTime
            hourlyTemperature.text = "\(forecastWeather.hourlyTemp)°C"
            iconImageView.image = UIImage(systemName: forecastWeather.hourlyIcon)
        }
    }
    
}
