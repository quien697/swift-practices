//
//  ViewController.swift
//  ISpy
//
//  Created by Quien on 2022/11/22.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    scrollView.delegate = self
    scrollView.minimumZoomScale = 0.1
    scrollView.maximumZoomScale = 5.0
  }
  
  override func viewDidAppear(_ animated: Bool) {
    updateZoomFor(size: view.bounds.size)
  }
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  func updateZoomFor(size: CGSize) {
    let widthScale = size.width / imageView.bounds.width
    let hightScale = size.height / imageView.bounds.height
    let scale = min(widthScale, hightScale)
    scrollView.minimumZoomScale = scale
    scrollView.zoomScale = scale
  }
  
}

