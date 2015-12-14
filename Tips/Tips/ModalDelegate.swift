//
//  ModalDelegate.swift
//  Tips
//
//  Created by Chase McCoy on 12/7/15.
//  Copyright © 2015 Chase McCoy. All rights reserved.
//

protocol ModalDelegate {
  func minimizeView() -> Void
  func maximizeView() -> Void
  func assignFirstResponder() -> Void
}