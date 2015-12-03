//
//  SettingsViewController.swift
//  Tips
//
//  Created by Chase McCoy on 12/2/15.
//  Copyright © 2015 Chase McCoy. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  
  @IBOutlet var tipControl: UISegmentedControl!
  @IBOutlet var colorSchemeControl: UISegmentedControl!
  
  override func viewDidLoad() {
    self.view.layer.insertSublayer(self.blueGradient(), atIndex: 0)
    
    self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), forBarMetrics: UIBarMetrics.Default)
    self.navigationController?.navigationBar.translucent = true
    self.navigationController?.view.backgroundColor = UIColor.clearColor()
    self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
  }
  
  override func viewWillAppear(animated: Bool) {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    tipControl.selectedSegmentIndex = defaults.integerForKey("defaultTip")
    colorSchemeControl.selectedSegmentIndex = defaults.integerForKey("colorScheme")
  }
  
  @IBAction func valueChanged(sender: AnyObject) {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    defaults.setInteger(tipControl.selectedSegmentIndex, forKey: "defaultTip")
    defaults.setInteger(colorSchemeControl.selectedSegmentIndex, forKey: "colorScheme")
    defaults.synchronize()
  }

  @IBAction func doneButton(sender: UIButton) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  func blueGradient() -> CAGradientLayer {
    let colorOne = UIColor.init(red: 0.379, green: 0.000, blue: 0.914, alpha: 1.0).CGColor
    let colorTwo = UIColor.init(red: 0.603, green: 0.154, blue: 0.699, alpha: 1.0).CGColor
    
    let returnLayer = CAGradientLayer()
    returnLayer.colors = [colorOne, colorTwo]
    returnLayer.locations = [0.0, 1.0]
    
    returnLayer.frame.size.width = self.view.frame.size.width + 10
    returnLayer.frame.size.height = self.view.frame.size.height
    returnLayer.frame.origin = CGPointMake(0, 0)
    
    return returnLayer
  }

}
