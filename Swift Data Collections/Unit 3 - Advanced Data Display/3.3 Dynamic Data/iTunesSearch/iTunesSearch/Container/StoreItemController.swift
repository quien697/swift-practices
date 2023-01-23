//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by Quien on 2023/1/10.
//

import Foundation
import UIKit

class StoreItemController {
  
  func fetchItems(matching query: [String: String]) async throws -> [StoreItem] {
    var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
    urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
    let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw StoreItemError.itemsNotFound
    }
    
    let decoder = JSONDecoder()
    let searchResponse = try decoder.decode(SearchResponse.self, from: data)
    
    return searchResponse.results
  }
  
  func fetchImage(from url: URL) async throws -> UIImage {
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
    urlComponents?.scheme = "https"
    
    let (data, response) = try await URLSession.shared.data(from: urlComponents!.url!)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw StoreItemError.imageDataMissing
    }
    guard let image = UIImage(data: data) else {
      throw StoreItemError.imageDataMissing
    }
    
    return image
  }
}

enum StoreItemError: Error {
  case itemsNotFound
  case imageDataMissing
}

extension StoreItemError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .itemsNotFound:
      return "StoresItems Not Found."
    case .imageDataMissing:
      return "Image Not Found."
    }
  }
}
