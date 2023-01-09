//
//  PhotoInfoController.swift
//  SpacePhoto
//
//  Created by Quien on 2023/1/5.
//

import Foundation

class PhotoInfoController {
  
  // singleton pattern - make sure only one instance of a class is instantiated and that your app only uses that instance
  static let shared = PhotoInfoController()
  
  private init() {}
  
  enum PhotoInfoError: Error, LocalizedError {
    case itemNotFound
    case imageDataMissing
  }
  
  func fetchPhotoInfo() async throws -> PhotoInfo {
    // https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=2022-01-05
    var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
    urlComponents.queryItems = ["api_key": "DEMO_KEY", "date": "2023-01-01"].map { URLQueryItem(name: $0.key, value: $0.value) }
    let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw PhotoInfoError.itemNotFound
    }
    
    // Convert JSON type to Swift type
    let jsonDecoder = JSONDecoder()
    let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
    return photoInfo
  }
  
}
