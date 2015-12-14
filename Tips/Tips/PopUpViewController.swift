//
//  PopUpViewController.swift
//  Tips
//
//  Created by Chase McCoy on 12/7/15.
//  Copyright © 2015 Chase McCoy. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
  @IBOutlet var backButton: SpringButton!
  @IBOutlet var popUpView: SpringView!
  
  @IBOutlet var tipControl: UISegmentedControl!
  @IBOutlet var colorSchemeControl: UISegmentedControl!
  
  var delegate: ModalDelegate?

  override func viewDidLoad() {
    popUpView.transform = CGAffineTransformMakeTranslation(0, 300)
    
    backButton.animate()
    popUpView.animate()
    
    self.setNeedsStatusBarAppearanceUpdate()
  }
  
  override func viewWillAppear(animated: Bool) {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    tipControl.selectedSegmentIndex = defaults.integerForKey("defaultTip")
    colorSchemeControl.selectedSegmentIndex = defaults.integerForKey("colorScheme")
    
    popUpView.backgroundColor = UIColor.clearColor()
    
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = popUpView.bounds
    blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    
    popUpView.insertSubview(blurEffectView, belowSubview: tipControl)
  }
  
  override func viewDidAppear(animated: Bool) {
    delegate?.minimizeView()
  }
  
  @IBAction func valueChanged(sender: AnyObject) {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    defaults.setInteger(tipControl.selectedSegmentIndex, forKey: "defaultTip")
    defaults.setInteger(colorSchemeControl.selectedSegmentIndex, forKey: "colorScheme")
    defaults.synchronize()
    
    NSNotificationCenter.defaultCenter().postNotificationName("settingsChanged", object: nil)
  }
  
  @IBAction func backPressed(sender: AnyObject) {
    delegate?.maximizeView()
    
    NSNotificationCenter.defaultCenter().postNotificationName("settingsChanged", object: nil)
    
    UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
      self.popUpView.transform = CGAffineTransformMakeTranslation(0, 300)
      self.backButton.alpha = 0
      }) { (completed: Bool) -> Void in
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    delegate?.assignFirstResponder()
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
}
