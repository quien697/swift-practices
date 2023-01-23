//
//  APIRequest.swift
//  Habits
//
//  Created by Quien on 2023/1/20.
//

import UIKit

protocol APIRequest {
  associatedtype Response
  
  var path: String { get }
  var queryItems: [URLQueryItem]? { get }
  var request: URLRequest { get }
  var postData: Data? { get }
}

extension APIRequest {
  var host: String { "localhost" }
  var port: Int { 8080 }
}

extension APIRequest {
  var queryItems: [URLQueryItem]? { nil }
  var postData: Data? { nil }
}

extension APIRequest {
  var request: URLRequest {
    var componets = URLComponents()
    componets.scheme = "http"
    componets.host = host
    componets.port = port
    componets.path = path
    componets.queryItems = queryItems
    
    var request = URLRequest(url: componets.url!)
    
    if let data = postData {
      request.httpBody = data
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpMethod = "POST"
    }
    
    return request
  }
}

enum APIRequestError: Error {
  case itemNotFound
  case requestFailed
}

extension APIRequest where Response: Decodable {
  func send() async throws -> Response {
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
      throw APIRequestError.itemNotFound
    }
    
    let decoder = JSONDecoder()
    let decoded = try decoder.decode(Response.self, from: data)
    
    return decoded
  }
}

extension APIRequest {
  func send() async throws -> Void {
    let (_, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
      throw APIRequestError.requestFailed
    }
  }
}

enum ImageRequestError: Error {
  case couldNotInitializeFromData
  case imageDataMissing
}

extension APIRequest where Response == UIImage {
  func send() async throws -> UIImage {
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw ImageRequestError.imageDataMissing
    }
    
    guard let image = UIImage(data: data) else {
      throw ImageRequestError.couldNotInitializeFromData
    }
    
    return image
  }
}
