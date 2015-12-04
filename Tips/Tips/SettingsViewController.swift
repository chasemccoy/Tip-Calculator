//
//  SettingsViewController.swift
//  Tips
//
//  Created by Chase McCoy on 12/2/15.
//  Copyright © 2015 Chase McCoy. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  
  @IBOutlet var defaultTipAmountLabel: UILabel!
  @IBOutlet var colorSchemeLabel: UILabel!
  @IBOutlet var tipControl: UISegmentedControl!
  @IBOutlet var colorSchemeControl: UISegmentedControl!
  
  var blueGradientLayer: CAGradientLayer! = nil
  var greenGradientLayer: CAGradientLayer! = nil
  
  override func viewDidLoad() {
    
    blueGradientLayer = blueGradient()
    greenGradientLayer = greenGradient()
    
    self.view.layer.insertSublayer(blueGradientLayer, atIndex: 0)
    self.view.layer.insertSublayer(greenGradientLayer, atIndex: 1)
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), forBarMetrics: UIBarMetrics.Default)
    self.navigationController?.navigationBar.translucent = true
    self.navigationController?.view.backgroundColor = UIColor.clearColor()
    self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
  }
  
  override func viewWillAppear(animated: Bool) {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    tipControl.selectedSegmentIndex = defaults.integerForKey("defaultTip")
    colorSchemeControl.selectedSegmentIndex = defaults.integerForKey("colorScheme")
    
    if defaults.integerForKey("colorScheme") == 0 {
      self.updateColorSchemeForDay()
    }
    else {
      self.updateColorSchemeForNight()
    }
  }
  
  @IBAction func valueChanged(sender: AnyObject) {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    defaults.setInteger(tipControl.selectedSegmentIndex, forKey: "defaultTip")
    defaults.setInteger(colorSchemeControl.selectedSegmentIndex, forKey: "colorScheme")
    defaults.synchronize()
    
    if colorSchemeControl.selectedSegmentIndex == 0 {
      self.updateColorSchemeForDay()
    }
    else {
      self.updateColorSchemeForNight()
    }
    
    self.setNeedsStatusBarAppearanceUpdate()
  }
  
  func updateColorSchemeForDay() {
    self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
    self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor()]
    
    blueGradientLayer.hidden = true
    greenGradientLayer.hidden = false
    
    defaultTipAmountLabel.textColor = UIColor.blackColor()
    colorSchemeLabel.textColor = UIColor.blackColor()
    
    tipControl.tintColor = UIColor.blackColor()
    colorSchemeControl.tintColor = UIColor.blackColor()
  }
  
  func updateColorSchemeForNight() {
    self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    
    blueGradientLayer.hidden = false
    greenGradientLayer.hidden = true
    
    defaultTipAmountLabel.textColor = UIColor.whiteColor()
    colorSchemeLabel.textColor = UIColor.whiteColor()
    
    tipControl.tintColor = UIColor.whiteColor()
    colorSchemeControl.tintColor = UIColor.whiteColor()
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
  
  func greenGradient() -> CAGradientLayer {
    //    let colorOne = UIColor(red:0.977, green:0.662, blue:0.009, alpha:1).CGColor
    //    let colorTwo = UIColor(red:0.902, green:0.233, blue:0.004, alpha:1).CGColor
    
    let colorOne = UIColor(red:0.773, green:0.983, blue:0.379, alpha:1).CGColor
    let colorTwo = UIColor(red:0.126, green:0.441, blue:0, alpha:1).CGColor
    
    let returnLayer = CAGradientLayer()
    returnLayer.colors = [colorOne, colorTwo]
    returnLayer.locations = [0.0, 1.0]
    
    returnLayer.frame.size.width = self.view.frame.size.width + 10
    returnLayer.frame.size.height = self.view.frame.size.height
    returnLayer.frame.origin = CGPointMake(0, 0)
    
    return returnLayer
  }


}
