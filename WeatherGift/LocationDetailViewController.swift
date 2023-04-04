//
//  LocationDetailViewController.swift
//  WeatherGift
//
//  Created by 顏逸修 on 2023/4/4.
//

import UIKit

class LocationDetailViewController: UIViewController {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var weatherLocation: WeatherLocation!
    var weatherLocations: [WeatherLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if weatherLocation == nil {
            weatherLocation = WeatherLocation(name: "Current Location", latitude: 0.0, longitude: 0.0)
            weatherLocations.append(weatherLocation)
        }
        
        loadLocations()
        updateUserInterface()
    }
    
    
    func loadLocations() {
        guard let data = UserDefaults.standard.value(forKey: "weatherLocations") as? Data else {
            print("⚠️ Warning: Couldn't load weatherLocations data from UserDefaults. This would always be the case the first time an app is installed, so if that's the case, ignore this error.")
            return
        }
        
        let jsonDecoder = JSONDecoder()
        
        if let weatherLocations = try? jsonDecoder.decode(Array.self, from: data) as [WeatherLocation] {
            self.weatherLocations = weatherLocations
        } else {
            print("😡 ERROR: Couldn't decode data read from UserDefaults.")
        }
    }
    
    
    func updateUserInterface() {
        dateLabel.text = ""
        placeLabel.text = weatherLocation.name
        temperatureLabel.text = "--°C"
        summaryLabel.text = ""
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! LocationListViewController
        destination.weatherLocations = weatherLocations
        
    }
    
    
    @IBAction func unwindFromLocationListViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! LocationListViewController
        weatherLocations = source.weatherLocations
        weatherLocation = weatherLocations[source.selectedlocationIndex]
        updateUserInterface()
    }

}
