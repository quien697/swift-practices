//
//  ViewController.swift
//  WorkingWithTheWeb
//
//  Created by Quien on 2023/1/8.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // workWithAPIAndJSON()
    
    Task {
      do {
        let photoInfo = try await fetchPhotoInfo()
        print("Successfully fetched PhotoInfo: \(photoInfo)")
      } catch {
        print("Fetch PhotoInfo failed with error: \(error)")
      }
    }
    
  }
  
  func fetchPhotoInfo() async throws -> PhotoInfo {
    var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
    urlComponents.queryItems = [ "api_key": "DEMO_KEY" ].map { URLQueryItem(name: $0.key, value: $0.value) }
    
    let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw PhotoInfoError.itemNotFound
    }
    
    let jsonDecoder = JSONDecoder()
    let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
    return(photoInfo)
  }
  
  func workWithAPIAndJSON() {
    var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
    urlComponents.queryItems = [ "api_key": "DEMO_KEY" ].map { URLQueryItem(name: $0.key, value: $0.value) }
    
    Task {
      let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
      
      let jsonDecoder = JSONDecoder()
      if let httpResponse = response as? HTTPURLResponse,
         httpResponse.statusCode == 200,
         let photoDictionary = try? jsonDecoder.decode([String: String].self, from: data) {
        print(photoDictionary)
      }
    }
  }
  
}

enum PhotoInfoError: Error, LocalizedError {
  case itemNotFound
  case imageDataMissing
}
