//
//  DatePickerTextField.swift
//  iXplore
//
//  Created by David Wallach on 7/14/16.
//  Copyright © 2016 David Wallach. All rights reserved.
//

import Foundation
import UIKit

extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.blueColor()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        return toolBar
    }
    
}

class UIDatePickerTextField: UITextField {
    
    let datePicker = UIDatePicker()
    var datePickerMode: UIDatePickerMode = .Date
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.inputView = datePicker
        setDate()
        datePicker.addTarget(self, action: #selector(setDate), forControlEvents: .ValueChanged)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.inputView = datePicker
        setDate()
        datePicker.addTarget(self, action: #selector(setDate), forControlEvents: .ValueChanged)
    }
    
    func setDate() {
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .LongStyle
        self.text = timeFormatter.stringFromDate(datePicker.date)
    }
    
}