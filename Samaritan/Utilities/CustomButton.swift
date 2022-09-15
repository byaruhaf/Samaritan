//
//  CustomButton.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 14/09/2022.
//

import UIKit.UIButton

class CustomButton: UIButton {
  override func awakeFromNib() {
    super.awakeFromNib()
    setUpView()
  }
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setUpView()
  }
  func setUpView() {
    self.layer.cornerRadius = self.frame.width/2
    self.layer.masksToBounds = true
  }
}

