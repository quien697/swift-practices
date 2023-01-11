//
//  SearchResponse.swift
//  iTunesSearch
//
//  Created by Quien on 2023/1/9.
//

import Foundation

struct SearchResponse: Codable {
  let results: [StoreItem]
}
