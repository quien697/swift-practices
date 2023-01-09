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
    // oldDataTask()
    // newDataTask()
    newDataTaskWithApi()
  }
  
  /// Example 1
  func oldDataTask() {
    // send a get request
    // 1. define the URL
    let url = URL(string: "https://www.apple.com")!
    
    // 2. create an URL session object
    let urlSession = URLSession.shared
    
    // 3. send a get request
    // Synchronous vs Asynchronous
    let request = URLRequest(url: url)
    let task = urlSession.dataTask(with: request) { data, response, error in
      if let httpResponse = response as? HTTPURLResponse,
         httpResponse.statusCode == 200,
         let data = data,
         let string = String(data: data, encoding: .utf8) {
        print("string = \(string)")
      } else {
        print("error")
      }
    }
    
    // send the request
    task.resume()
  }
  
  /// Example 2
  func newDataTask() {
    let url = URL(string: "https://www.apple.com")!
    Task {
      do {
        let (data, response) = try await URLSession.shared.data(from: url)
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200,
           let string = String(data: data, encoding: .utf8) {
          print(string)
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  /// Example 3
  func newDataTaskWithApi() {
    // https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=2023-01-01
    var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
    urlComponents.queryItems = ["api_key": "DEMO_KEY", "date": "2023-01-01"].map { URLQueryItem(name: $0.key, value: $0.value) }
    Task {
      let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
      
      if let httpResponse = response as? HTTPURLResponse,
         httpResponse.statusCode == 200,
         let string = String(data: data, encoding: .utf8) {
        print(string)
      }
    }
  }
  
}

