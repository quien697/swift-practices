//
//  ViewController.swift
//  MusicWireframe
//
//  Created by Quien on 2023/1/4.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var albumImageView: UIImageView!
  
  @IBOutlet var reverseBackground: UIView!
  @IBOutlet var playPauseBackground: UIView!
  @IBOutlet var forwardBackground: UIView!
  
  @IBOutlet weak var reverseButton: UIButton!
  @IBOutlet weak var playPauseButton: UIButton!
  @IBOutlet weak var forwardButton: UIButton!
  
  var isPlaying: Bool = true {
    didSet {
      playPauseButton.isSelected = isPlaying
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    [reverseBackground, playPauseBackground,
     forwardBackground].forEach { view in
      view?.layer.cornerRadius = view!.frame.height / 2
      view?.clipsToBounds = true
      view?.alpha = 0.0
    }
    
  }
  
  // MARK: - Action
  
  @IBAction func playPauseButtonTapped(_ sender: UIButton) {
    isPlaying.toggle()
    
    if isPlaying {
      UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: [], animations: {
        self.albumImageView.transform = CGAffineTransform.identity
      }, completion: nil)
    } else {
      UIView.animate(withDuration: 0.5) {
        self.albumImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
      }
    }
  }
  
  @IBAction func touchedUpInside(_ sender: UIButton) {
    let buttonBackground: UIView
    
    switch sender {
    case reverseButton:
      buttonBackground = reverseBackground
    case playPauseButton:
      buttonBackground = playPauseBackground
    case forwardButton:
      buttonBackground = forwardBackground
    default:
      return
    }
    
    UIView.animate(withDuration: 0.25, animations: {
      buttonBackground.alpha = 0.0
      buttonBackground.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
      sender.transform = CGAffineTransform.identity
    }) { (_) in
      buttonBackground.transform = CGAffineTransform.identity
    }
  }
  
  
  @IBAction func touchedDown(_ sender: UIButton) {
    let buttonBackground: UIView
    
    switch sender {
    case reverseButton:
      buttonBackground = reverseBackground
    case playPauseButton:
      buttonBackground = playPauseBackground
    case forwardButton:
      buttonBackground = forwardBackground
    default:
      return
    }
    
    UIView.animate(withDuration: 0.25) {
      buttonBackground.alpha = 0.3
      sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
  }
  
  
}

