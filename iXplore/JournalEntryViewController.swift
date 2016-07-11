//
//  JournalEntryViewController.swift
//  iXplore
//
//  Created by David Wallach on 7/11/16.
//  Copyright © 2016 David Wallach. All rights reserved.
//

import UIKit
import MapKit

private extension Selector {
    static let saveButton = #selector(JournalEntryViewController.saveButtonTapped)
    static let cancelButton = #selector(JournalEntryViewController.cancelButtonTapped)
}

class JournalEntry: NSObject, MKAnnotation {
    var title: String? = ""
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var mysubtitle: String = ""
}

class JournalEntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleField = UITextField(frame: CGRect(x: 20, y: 60, width: 200, height: 100))
        titleField.placeholder = "Title"
        let notesField = UITextField(frame: CGRect(x: 20, y: 115, width: 200, height: 100))
        notesField.placeholder = "Notes"
        let xCoordinates = UITextField(frame: CGRect(x: 20, y: 175, width: 200, height: 100))
        xCoordinates.placeholder = "X-Coordinate"
        let yCoordinates = UITextField(frame: CGRect(x: 200, y: 175, width: 200, height: 100))
        yCoordinates.placeholder = "Y-Coordinate"
        view.addSubview(titleField)
        view.addSubview(notesField)
        view.addSubview(xCoordinates)
        view.addSubview(yCoordinates)
        
        let cancelButton = UIButton(frame: CGRect(x: 20, y: 220, width: 75, height: 75))
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.titleLabel!.font = UIFont(name: "Arial", size: 15)
        cancelButton.setTitleColor(UIColor .blueColor(), forState: .Normal)
        cancelButton.addTarget(self, action: .cancelButton, forControlEvents: .TouchUpInside)
//        cancelButton.targetForAction(.cancelButton, withSender: self)
        let saveButton = UIButton(frame: CGRect(x: 200, y: 220, width: 75, height: 75))
        saveButton.setTitle("Save", forState: .Normal)
//        saveButton.targetForAction(.saveButton, withSender: self)
        saveButton.addTarget(self, action: .saveButton, forControlEvents: .TouchUpInside)
        saveButton.titleLabel!.font = UIFont(name: "Arial", size: 15)
        saveButton.setTitleColor(UIColor .blueColor(), forState: .Normal)
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveButtonTapped() {
        
    }
    
    func cancelButtonTapped() {
        navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
