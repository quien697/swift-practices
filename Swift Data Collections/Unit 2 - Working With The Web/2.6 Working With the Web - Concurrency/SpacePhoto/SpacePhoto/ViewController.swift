//
//  ViewController.swift
//  SpacePhoto
//
//  Created by Quien on 2023/1/5.
//

import UIKit

class ViewController: UIViewController {
  
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var copyrightLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    initUI()
    
    Task {
      do {
        let photo = try await PhotoInfoController.shared.fetchPhotoInfo()
        updateUI(with: photo)
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
      } catch {
        updateUI(with: error)
      }
    }
  }
  
  func initUI() {
    title = ""
    imageView.image = UIImage(systemName: "photo.on.rectangle")
    descriptionLabel.text = ""
    copyrightLabel.text = ""
    activityIndicator.startAnimating()
  }
  
  func updateUI(with photoInfo: PhotoInfo) {
    Task {
      do {
        let image = try await PhotoInfoController.shared.fetchImage(from: photoInfo.url)
        title = photoInfo.title
        imageView.image = image
        descriptionLabel.text = photoInfo.description
        copyrightLabel.text = photoInfo.copyright
      } catch {
        updateUI(with: error)
      }
    }
  }
  
  func updateUI(with error: Error) {
    title = "Error Fetching Photo"
    imageView.image = UIImage(systemName: "exclamationmark.octagon")
    descriptionLabel.text = error.localizedDescription
    copyrightLabel.text = ""
  }
  
  
  /// Old way : GCD(Grand Central Dispatch)
  func oldGCDUpdateUI() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateStr = formatter.string(from: Date())
    
    var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
    urlComponents.queryItems = ["api_key": "DEMO_KEY", "date": dateStr].map { URLQueryItem(name: $0.key, value: $0.value) }
    let urlRequest = URLRequest(url: urlComponents.url!)
    // long-running task (background thread)
    let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
      if error != nil {
        return
      }
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        return
      }
      let jsonDecoder = JSONDecoder()
      if let photoInfo = try? jsonDecoder.decode(PhotoInfo.self, from: data!) {
        DispatchQueue.main.async {
          // Update UI (MUST run on the main)
          self.descriptionLabel.text = photoInfo.description
        }
      }
    }
    task.resume()
  }
  
}

