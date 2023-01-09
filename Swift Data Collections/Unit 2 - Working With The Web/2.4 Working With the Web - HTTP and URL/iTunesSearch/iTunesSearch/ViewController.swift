//
//  ViewController.swift
//  iTunesSearch
//
//  Created by Quien on 2023/1/8.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
    let query: [String: String] = [
      "term": "Brave",
      "media": "music"]
    urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
    
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

