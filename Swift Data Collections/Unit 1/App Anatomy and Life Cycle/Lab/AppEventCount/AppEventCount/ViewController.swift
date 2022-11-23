//
//  ViewController.swift
//  AppEventCount
//
//  Created by Quien on 2022/11/22.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var appLaunchLabel: UILabel!
  @IBOutlet weak var appConfigurationForConnectingLabel: UILabel!
 
  @IBOutlet weak var sceneWillConnectLabel: UILabel!
  @IBOutlet weak var sceneDidBecomeActiveLabel: UILabel!
  @IBOutlet weak var sceneWillResignActiveLabel: UILabel!
  @IBOutlet weak var sceneWillEnterForegroundLabel: UILabel!
  @IBOutlet weak var sceneDidEnterBackgroundLabel: UILabel!
  
  var willConnectCount = 0
  var didBecomeActiveCount = 0
  var willResignActiveCount = 0
  var willEnterForegroundCount = 0
  var didEnterBackgroundCount = 0
  
  var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
//  var sceneDelegate = (UIApplication.shared.delegate as! SceneDelegate)

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  func updateView() {
    appLaunchLabel.text = "The App has Launched \(appDelegate.launchCount) time(s)."
    appConfigurationForConnectingLabel.text = "appConfigurationForConnecting \(appDelegate.configurationForConnectingCount) time(s)."
    sceneWillConnectLabel.text = "sceneWillConnect \(willConnectCount) time(s)."
    sceneDidBecomeActiveLabel.text = "sceneDidBecomeActive \(didBecomeActiveCount) time(s)."
    sceneWillResignActiveLabel.text = "sceneWillResignActive \(willResignActiveCount) time(s)."
    sceneWillEnterForegroundLabel.text = "sceneWillEnterForeground \(willEnterForegroundCount) time(s)."
    sceneDidEnterBackgroundLabel.text = "sceneDidEnterBackground \(didEnterBackgroundCount) time(s)."
  }

}

