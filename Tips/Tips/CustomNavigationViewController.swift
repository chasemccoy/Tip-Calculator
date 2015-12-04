//
//  CustomNavigationViewController.swift
//  Tips
//
//  Created by Chase McCoy on 12/2/15.
//  Copyright © 2015 Chase McCoy. All rights reserved.
//

import UIKit

class CustomNavigationViewController: UINavigationController {
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    if defaults.integerForKey("colorScheme") == 0 {
      return .Default
    }
    else {
      return .LightContent
    }
  }

}
