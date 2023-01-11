//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by Quien on 2023/1/9.
//

import Foundation

struct StoreItem: Codable {
  var name: String
  var artist: String
  var kind: String
  var artworkURL: URL
  var description: String
  
  enum CodingKeys: String, CodingKey {
    case name = "trackName"
    case artist = "artistName"
    case kind
    case artworkURL = "artworkUrl30"
    case description
  }
  
  enum AdditionalKeys: String, CodingKey {
    case longDescription
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: CodingKeys.name)
    self.artist = try container.decode(String.self, forKey: CodingKeys.artist)
    self.kind = try container.decode(String.self, forKey: CodingKeys.kind)
    self.artworkURL = try container.decode(URL.self, forKey: CodingKeys.artworkURL)
    
    if let description = try? container.decode(String.self, forKey: CodingKeys.description) {
      self.description = description
    } else {
      let additionalValues = try decoder.container(keyedBy: AdditionalKeys.self)
      self.description = (try? additionalValues.decode(String.self, forKey: AdditionalKeys.longDescription)) ?? ""
    }
  }
}
