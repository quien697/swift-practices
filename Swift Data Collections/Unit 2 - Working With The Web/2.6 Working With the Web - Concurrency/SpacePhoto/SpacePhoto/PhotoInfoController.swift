//
//  PhotoInfoController.swift
//  SpacePhoto
//
//  Created by Quien on 2023/1/5.
//

import Foundation
import UIKit

class PhotoInfoController {
  
  // singleton pattern - make sure only one instance of a class is instantiated and that your app only uses that instance
  static let shared = PhotoInfoController()
  
  private init() {}
  
  func fetchPhotoInfo() async throws -> PhotoInfo {
    // https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=2022-01-05
    
    // DateFormatter
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let todayDateStr = formatter.string(from: Date())
    
    var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
    urlComponents.queryItems = ["api_key": "DEMO_KEY", "date": todayDateStr].map { URLQueryItem(name: $0.key, value: $0.value) }
    let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw PhotoInfoError.itemNotFound
    }
    
    // Convert JSON type to Swift type
    let jsonDecoder = JSONDecoder()
    let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
    return photoInfo
  }
  
  func fetchImage(from url: URL) async throws -> UIImage {
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
    urlComponents?.scheme = "https"
    
    let (data, response) = try await URLSession.shared.data(from: urlComponents!.url!)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw PhotoInfoError.imageDataMissing
    }
    guard let image = UIImage(data: data) else {
      throw PhotoInfoError.imageDataMissing
    }
    
    return image
  }
  
}

enum PhotoInfoError: Error {
  case itemNotFound
  case imageDataMissing
}

extension PhotoInfoError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .itemNotFound:
      return "PhotoInfo Not Found."
    case .imageDataMissing:
      return "Image Not Found."
    }
  }
}
