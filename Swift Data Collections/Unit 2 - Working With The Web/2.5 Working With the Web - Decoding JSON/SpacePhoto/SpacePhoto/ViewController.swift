//
//  ViewController.swift
//  SpacePhoto
//
//  Created by Quien on 2023/1/5.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // newDataTaskWithJson()
    
    Task {
      let photo = try await PhotoInfoController.shared.fetchPhotoInfo()
      print(photo)
    }
  }
  
  /// Example
  func newDataTaskWithJson() {
    // https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=2023-01-01
    var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
    urlComponents.queryItems = ["api_key": "DEMO_KEY", "date": "2023-01-01"].map { URLQueryItem(name: $0.key, value: $0.value) }
    Task {
      let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
      let jsonDecoder = JSONDecoder()
      if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
        // Convert JSON type to Swift type
        if let photoInfo = try? jsonDecoder.decode(PhotoInfo.self, from: data) {
          print(photoInfo)
        }
      }
    }
  }
  
}

