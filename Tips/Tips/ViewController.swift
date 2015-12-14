//
//  ViewController.swift
//  Tips
//
//  Created by Chase McCoy on 11/30/15.
//  Copyright © 2015 Chase McCoy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, ModalDelegate {
  
  // ******************************************************
  // Properties
  // ******************************************************
  
  // MARK: - Properties
  
  // UIView Outlets
  @IBOutlet var fieldView: UIView!
  @IBOutlet var containerView: UIView!
  @IBOutlet var scrollView: UIScrollView!
  
  // UILabel Outlets
  @IBOutlet var tipLabel: SpringLabel!
  @IBOutlet var totalLabel: SpringLabel!
  @IBOutlet var TwoPeopleOutlet: SpringLabel!
  @IBOutlet var ThreePeopleOutlet: SpringLabel!
  @IBOutlet var FourPeopleOutlet: SpringLabel!
  @IBOutlet var FivePeopleOutlet: SpringLabel!
  
  // UISegmentedControl Outlets
  @IBOutlet var tipControl: UISegmentedControl!
  
  // UITextField Outlets
  @IBOutlet var billField: UITextField!
  
  // UIButton Outlets
  @IBOutlet var settingsIcon: UIButton!
  
  // NSLayoutConstraint Outlets
  @IBOutlet var heightConstraint: NSLayoutConstraint! // Constraint for the fieldView
  @IBOutlet var scrollViewHeightConstraint: NSLayoutConstraint!
  
  // Class Variables
  var keyboardFrame: CGRect!
  
  var blueGradientLayer: CAGradientLayer! = nil
  var orangeGradientLayer: CAGradientLayer! = nil
  
  var blueGradientTopLayer: CAGradientLayer! = nil
  var orangeGradientTopLayer: CAGradientLayer! = nil
  
  
  
  
  // ******************************************************
  // Methods
  // ******************************************************
  
  // MARK: - Methods

  override func viewDidLoad() {
    super.viewDidLoad()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "settingsChanged:", name: "settingsChanged", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "intializeBillField:", name: UIApplicationWillEnterForegroundNotification, object: nil)
    
    // Setup the notification to be alerted when the keyboard is shown
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    billField.keyboardType = .DecimalPad
    
    // Setup the UITextFieldDelegate
    billField.delegate = self
    
    // Setup the initial strings and such
    tipLabel.text = "$0.00"
    totalLabel.text = "$0.00"
    
    // Setup the initial layout of the app
    heightConstraint.constant = view.frame.size.height
    fieldView.clipsToBounds = true
    
    blueGradientLayer = self.blueGradient()
    orangeGradientLayer = self.orangeGradient()
    self.view.layer.insertSublayer(blueGradientLayer, atIndex: 0)
    self.view.layer.insertSublayer(orangeGradientLayer, atIndex: 1)
    
    blueGradientTopLayer = self.blueGradient()
    orangeGradientTopLayer = self.orangeGradient()
    fieldView.layer.insertSublayer(blueGradientTopLayer, atIndex: 0)
    fieldView.layer.insertSublayer(orangeGradientTopLayer, atIndex: 1)
    
    self.containerView.backgroundColor = UIColor.clearColor()
    
    // Setup the monospaced fonts for all numeric values
    tipLabel.font = UIFont.monospacedDigitSystemFontOfSize(tipLabel.font.pointSize, weight: UIFontWeightRegular)
    totalLabel.font = UIFont.monospacedDigitSystemFontOfSize(totalLabel.font.pointSize, weight: UIFontWeightBold)
    TwoPeopleOutlet.font = UIFont.monospacedDigitSystemFontOfSize(TwoPeopleOutlet.font.pointSize, weight: UIFontWeightRegular)
    ThreePeopleOutlet.font = UIFont.monospacedDigitSystemFontOfSize(ThreePeopleOutlet.font.pointSize, weight: UIFontWeightRegular)
    FourPeopleOutlet.font = UIFont.monospacedDigitSystemFontOfSize(FourPeopleOutlet.font.pointSize, weight: UIFontWeightRegular)
    FivePeopleOutlet.font = UIFont.monospacedDigitSystemFontOfSize(FivePeopleOutlet.font.pointSize, weight: UIFontWeightRegular)
  }
  
  
  
  
  override func viewWillAppear(animated: Bool) {
    // Always show the keyboard first things
    billField.becomeFirstResponder()
    
    self.updateView()
    
    TwoPeopleOutlet.alpha = 0.75
    ThreePeopleOutlet.alpha = 0.68
    FourPeopleOutlet.alpha = 0.58
    FivePeopleOutlet.alpha = 0.50
  }
  
  
  
  
  override func viewDidAppear(animated: Bool) {
    let defaults = NSUserDefaults.standardUserDefaults()
    let colorScheme = defaults.integerForKey("colorScheme")
    
    if colorScheme == 0 {
      settingsIcon.imageView?.image = UIImage.init(named: "darkGear")
    }
    else {
      settingsIcon.imageView?.image = UIImage.init(named: "lightGear")
    }
  }
  
  
  
  
  override func viewWillDisappear(animated: Bool) {
    // This is done to prevent a bug in iOS from messing up the keyboard
    // when dismissing the modal settings view controller
    billField.resignFirstResponder()
  }
  
  
  
  func updateView() {
    let defaults = NSUserDefaults.standardUserDefaults()
    let tipIndex: Int? = defaults.integerForKey("defaultTip")
    let colorScheme = defaults.integerForKey("colorScheme")
    
    if let tip = tipIndex {
      tipControl.selectedSegmentIndex = tip
    }
    else {
      tipControl.selectedSegmentIndex = 0
    }
    
    // Day
    if colorScheme == 0 {
      self.setupDayTheme()
    }
      // Night
    else {
      self.setupNightTheme()
    }
  }

  
  
  
  @IBAction func onEditingChanged(sender: AnyObject) {
    let defaults = NSUserDefaults.standardUserDefaults()
    let lastEdit = NSDate()
    
    defaults.setObject(billField.text, forKey: "billAmount")
    defaults.setObject(lastEdit, forKey: "lastEdit")
    defaults.synchronize()
    
    let tipPercentages = [0.18, 0.20, 0.25]
    let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
    
    var tip = 0.0
    var total = 0.0
    
    if let billAmount = Double(billField.text!) {
      tip = billAmount * tipPercentage
      total = billAmount + tip
    }
    
    if billField.text!.containsString(".") || billField.text?.characters.count == 0 {
      billField.keyboardType = .NumberPad
    }
    else {
      billField.keyboardType = .DecimalPad
    }
    billField.reloadInputViews()
    
    if (tip != 0) {
      if heightConstraint.constant != 100 {
        heightConstraint.constant = 100
        UIView.animateWithDuration(0.5, animations: {self.view.layoutIfNeeded()})
        self.animateLabels()
      }
    }
    else {
      heightConstraint.constant = self.view.frame.size.height
      UIView.animateWithDuration(0.5, animations: {self.view.layoutIfNeeded()})
      scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    // Create a number formatter to localize the currency strings
    let formatter = NSNumberFormatter()
    formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
    formatter.locale = NSLocale.currentLocale()
    
    let localizedTipString = formatter.stringFromNumber(tip)
    let localizedTotalSting = formatter.stringFromNumber(total)
    let localizedTwoPeopleString = formatter.stringFromNumber(total / 2)
    let localizedThreePeopleString = formatter.stringFromNumber(total / 3)
    let localizedFourPeopleString = formatter.stringFromNumber(total / 4)
    let localizedFivePeopleString = formatter.stringFromNumber(total / 5)
    
    tipLabel.text = localizedTipString
    totalLabel.text = localizedTotalSting
    
    TwoPeopleOutlet.text = localizedTwoPeopleString
    ThreePeopleOutlet.text = localizedThreePeopleString
    FourPeopleOutlet.text = localizedFourPeopleString
    FivePeopleOutlet.text = localizedFivePeopleString
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "PopUpSegue" {
      let popUpController = segue.destinationViewController as! PopUpViewController
      popUpController.delegate = self
    }
  }
  
  // Used to call the modal segue that opens the settings view
  @IBAction func openSettings(sender: AnyObject) {
    billField.resignFirstResponder()
    self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
    performSegueWithIdentifier("PopUpSegue", sender: sender)
  }
  
  // Used to dismiss the settings screen 
  // Called by the first responder in the Settings View Controller
  @IBAction func dismissSettings(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func minimizeView() {
    SpringAnimation.spring(0.7, animations: {
      self.view.transform = CGAffineTransformMakeScale(0.935, 0.935)
    })
  }
  
  func maximizeView() {
    SpringAnimation.spring(0.7, animations: {
      self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
    })
  }
  
  func assignFirstResponder() {
    billField.becomeFirstResponder()
  }
  
 
  
  // ******************************************************
  // Helper Methods
  // ******************************************************
  
  // MARK: - Helper Methods
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  
  func settingsChanged(notification: NSNotification) {
    updateView()
    onEditingChanged(self)
  }
  
  
  
  func intializeBillField(notification: NSNotification) {
    // Determine how long since the last edit, and pull in the old data if less than 10 minutes
    let defaults = NSUserDefaults.standardUserDefaults()
    let lastEdit: NSDate? = defaults.objectForKey("lastEdit") as! NSDate?
    if lastEdit != nil {
      let timeInterval: NSTimeInterval = NSDate().timeIntervalSinceDate(lastEdit!)
      if Int(timeInterval) <= 600 {
        billField.text = (defaults.objectForKey("billAmount") as! String)
        self.onEditingChanged(self)
      }
      else {
        billField.text = ""
        self.onEditingChanged(self)
      }
    }
  }
  
  
  
  func setupDayTheme() {
    blueGradientLayer.hidden = true
    orangeGradientLayer.hidden = false
    
    blueGradientTopLayer.hidden = true
    orangeGradientTopLayer.hidden = false
    
    self.scrollView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.1)
    
    billField.textColor = UIColor(red:0, green:0, blue:0, alpha:0.5)
    self.setNeedsStatusBarAppearanceUpdate()
    billField.keyboardAppearance = UIKeyboardAppearance.Light
    
    let str = NSAttributedString(string: "Bill Amount", attributes: [NSForegroundColorAttributeName:UIColor(red:0, green:0, blue:0, alpha:0.2)])
    billField.attributedPlaceholder = str
    
    settingsIcon.imageView?.image = UIImage.init(named: "darkGear")
    
    billField.tintColor = UIColor(red:0, green:0, blue:0, alpha:0.2)
  }
  
  
  
  func setupNightTheme() {
    blueGradientLayer.hidden = false
    orangeGradientLayer.hidden = true
    
    blueGradientTopLayer.hidden = false
    orangeGradientTopLayer.hidden = true
    
    self.scrollView.backgroundColor = UIColor.init(white: 1.0, alpha: 0.2)
    
    billField.textColor = UIColor.whiteColor()
    self.setNeedsStatusBarAppearanceUpdate()
    billField.keyboardAppearance = UIKeyboardAppearance.Dark
    
    let str = NSAttributedString(string: "Bill Amount", attributes: [NSForegroundColorAttributeName:UIColor.init(white: 1.0, alpha: 0.5)])
    billField.attributedPlaceholder = str
    
    settingsIcon.imageView?.image = UIImage.init(named: "lightGear")
    
    billField.tintColor = UIColor.init(white: 1.0, alpha: 0.4)
  }
  
  
  
  func animateLabels() {
    tipLabel.animation = "slideLeft"
    tipLabel.duration = 1.2
    tipLabel.delay = 0.2
    tipLabel.curve = "linear"
    
    totalLabel.animation = "slideLeft"
    totalLabel.duration = 1.2
    totalLabel.delay = 0.2
    totalLabel.curve = "linear"
    
    TwoPeopleOutlet.animation = "slideLeft"
    TwoPeopleOutlet.duration = 1.2
    TwoPeopleOutlet.delay = 0.2
    TwoPeopleOutlet.curve = "linear"
    
    ThreePeopleOutlet.animation = "slideLeft"
    ThreePeopleOutlet.duration = 1.2
    ThreePeopleOutlet.delay = 0.2
    ThreePeopleOutlet.curve = "linear"
    
    FourPeopleOutlet.animation = "slideLeft"
    FourPeopleOutlet.duration = 1.2
    FourPeopleOutlet.delay = 0.2
    FourPeopleOutlet.curve = "linear"
    
    FivePeopleOutlet.animation = "slideLeft"
    FivePeopleOutlet.duration = 1.2
    FivePeopleOutlet.delay = 0.2
    FivePeopleOutlet.curve = "linear"
    
    tipLabel.animate()
    totalLabel.animate()
    TwoPeopleOutlet.animate()
    ThreePeopleOutlet.animate()
    FourPeopleOutlet.animate()
    FivePeopleOutlet.animate()
  }
  
  
  
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    let currentCharacterCount = textField.text?.characters.count ?? 0
    if (range.length + range.location > currentCharacterCount){
      return false
    }
    let newLength = currentCharacterCount + string.characters.count - range.length
    return newLength <= 8
  }
  
  
  
  
  func keyboardWillShow(notification: NSNotification) {
    keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    
    scrollViewHeightConstraint.constant = view.frame.size.height - keyboardFrame.size.height - 100
  }
  
  
  
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    let defaults = NSUserDefaults.standardUserDefaults()
    let colorScheme = defaults.integerForKey("colorScheme")
    
    if colorScheme == 0 {
      return .Default
    }
    else {
      return .LightContent
    }
  }
  
  
  
  
  func blueGradient() -> CAGradientLayer {
    let colorOne = UIColor.init(red: 0.379, green: 0.000, blue: 0.914, alpha: 1.0).CGColor
    let colorTwo = UIColor.init(red: 0.603, green: 0.154, blue: 0.699, alpha: 1.0).CGColor
    
    let returnLayer = CAGradientLayer()
    returnLayer.colors = [colorOne, colorTwo]
    returnLayer.locations = [0.0, 1.0]
    
    returnLayer.frame = self.view.frame
    
    return returnLayer
  }
  
  func orangeGradient() -> CAGradientLayer {
//    let colorOne = UIColor(red:0.977, green:0.662, blue:0.009, alpha:1).CGColor
//    let colorTwo = UIColor(red:0.902, green:0.233, blue:0.004, alpha:1).CGColor
    
    let colorOne = UIColor(red:0.773, green:0.983, blue:0.379, alpha:1).CGColor
    let colorTwo = UIColor(red:0.126, green:0.441, blue:0, alpha:1).CGColor
    
    let returnLayer = CAGradientLayer()
    returnLayer.colors = [colorOne, colorTwo]
    returnLayer.locations = [0.0, 1.0]
    
    returnLayer.frame = self.view.frame
    
    return returnLayer
  }

}

