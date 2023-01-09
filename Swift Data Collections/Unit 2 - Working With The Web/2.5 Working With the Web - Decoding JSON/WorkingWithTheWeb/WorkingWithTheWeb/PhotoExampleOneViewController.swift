//
//  PhotoExampleOneViewController.swift
//  WorkingWithTheWeb
//
//  Created by Quien on 2023/1/8.
//

import UIKit

// Example1: Add to the View Controller
class PhotoExampleOneViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Task {
      do {
        let photoInfo = try await fetchPhotoInfo1()
        updateUI(with: photoInfo)
      } catch {
        displayError(error)
      }
    }
  }
  
  func updateUI(with photoInfo: PhotoInfo){ }
  
  func displayError(_ error: Error){ }
  
  func fetchPhotoInfo1() async throws -> PhotoInfo {
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
}
