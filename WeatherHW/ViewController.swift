//
//  ViewController.swift
//  WeatherHW
//
//  Created by Нургазы on 23/1/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var feelslikeView: UIView!
    @IBOutlet weak var weatherStack: UIStackView!
    @IBOutlet weak var detailsStack: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var weatherResult: WeatherResult? = nil
    var dataTask: URLSessionTask? = nil
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        
        return dateFormatter
    }
    
    struct Colors {
        static let ocean = UIColor.init(red: 0.271, green: 0.973, blue: 0.753, alpha: 1).cgColor
        static let sky = UIColor.init(red: 0.271, green: 0.439, blue: 0.973, alpha: 1).cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        feelslikeView.layer.cornerRadius = 8
        
        cityLabel.text = "Enter city name"
        timeLabel.text = ""
        
        weatherStack.alpha = 0
        detailsStack.alpha = 0
        
        let gradient = CAGradientLayer()
        gradient.colors = [Colors.ocean, Colors.sky]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradient.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -1, b: 0.97, c: -0.97, d: -3.16, tx: 1.48, ty: 1.59))
        gradient.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        gradient.position = view.center
        view.layer.addSublayer(gradient)
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func showWeatherResult() {
        if let weatherResult = weatherResult {
            
            cityLabel.text = weatherResult.name
            descriptionLabel.text = weatherResult.weather.first?.main ?? "N/A"
            tempLabel.text = "\(Int(weatherResult.main.temp))°"
            tempMaxLabel.text = "\(Int(weatherResult.main.temp_max))℃"
            tempMinLabel.text = "\(Int(weatherResult.main.temp_min))℃"
            feelsLikeLabel.text = "\(weatherResult.main.feels_like)°"
            windLabel.text = "\(weatherResult.wind.speed) m/s"
            humidityLabel.text = "\(weatherResult.main.humidity) %"
            pressureLabel.text = "\(weatherResult.main.pressure) hPa"
            visibilityLabel.text = "\(Int(weatherResult.visibility)) m"
            cloudsLabel.text = "\(weatherResult.clouds.all) %"
            timeLabel.text = dateFormatter.string(from: Date())
            
            if let id = weatherResult.weather.first?.id {
                
                let icon: UIImage
                
                switch id {
                case 200..<300:
                    icon = UIImage(systemName: "cloud.bolt")!
                case 300..<400:
                    icon = UIImage(systemName: "cloud.drizzle")!
                case 500..<600:
                    icon = UIImage(systemName: "cloud.rain")!
                case 600..<700:
                    icon = UIImage(systemName: "cloud.snow")!
                case 700..<800:
                    icon = UIImage(systemName: "cloud.fog")!
                case 800:
                    icon = UIImage(systemName: "sun.max")!
                case 801:
                    icon = UIImage(systemName: "cloud.sun")!
                case 802:
                    icon = UIImage(systemName: "cloud.sun")!
                case 803:
                    icon = UIImage(systemName: "cloud")!
                case 804:
                    icon = UIImage(systemName: "smoke")!
                default:
                    icon = UIImage(systemName: "questionmark")!
                }
                
                iconImageView.image = icon
                
            }
            
            UIView.animate(withDuration: 0.3) {
                self.weatherStack.alpha = 1
                self.detailsStack.alpha = 1
            }
        }
    }
    
    func weatherURL(searchText: String) -> URL {
        
        let encoded = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(encoded)&appid=f38011e10ba8be0a1557b8cc47a59837&units=metric"
        
        return URL(string: urlString)!
    }
    
    func parse(data: Data) -> WeatherResult? {
        let decoder = JSONDecoder()
        
        do {
            let result = try decoder.decode(WeatherResult.self, from: data)
            return result
        } catch {
            print("JSON parsing Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Error", message: "There was an error accessing the weather data. Please try again", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func performSearch() {
        
        UIView.animate(withDuration: 0.3) {
            self.weatherStack.alpha = 0
            self.detailsStack.alpha = 0
        }
        
        activityIndicator.startAnimating()
        searchBar.resignFirstResponder()
        weatherResult = nil
        dataTask?.cancel()
        
        let url = weatherURL(searchText: searchBar.text!)
        
        let session = URLSession.shared
        
        // Bishkek - 10sec, New York
        dataTask = session.dataTask(with: url) { (data, response, error) in
            if let error = error as NSError?, error.code == -999 {
                return
            } else if let data = data, let httpRespone = response as? HTTPURLResponse, httpRespone.statusCode == 200 {
                
                self.weatherResult = self.parse(data: data)
                
                DispatchQueue.main.async {
                    self.showWeatherResult()
                    self.activityIndicator.stopAnimating()
                }
            } else {
                print("ERROR")
                
                DispatchQueue.main.async {
                    self.showNetworkError()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
        dataTask?.resume()
        
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        .topAttached
    }
}


// KEY = f38011e10ba8be0a1557b8cc47a59837

