//
//  ViewController.swift
//  iTunesSearch
//
//  Created by Quien on 2023/1/8.
//

import UIKit

class ViewController: UIViewController {
  
  let query = [
    "term": "Brave",
    "media": "music",
    "limit": "10"
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Task {
      do {
        let storeItems = try await fetchItems(matching: query)
        storeItems.forEach { item in
          print("""
                Name: \(item.name)
                Artist: \(item.artist)
                Kind: \(item.kind)
                Description: \(item.description)
                Artwork URL: \(item.artworkURL)
                """)
        }
      } catch {
        print(error)
      }
    }
  }
  
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
  
}
