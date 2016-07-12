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
    var title: String? = "hello"
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var mysubtitle: String = ""
    var date: NSDate = NSDate(timeIntervalSinceReferenceDate: 12/2/2)
}

class JournalEntryViewController: UIViewController {
    
    static var sharedInstance = JournalEntryViewController()
    var journalEntryList: [JournalEntry] = [JournalEntry]()
    
    func fillDummyArray() {
        let entry = JournalEntry()
        let entry2 = JournalEntry()
        let entry3 = JournalEntry()
        entry.title = "Workshop 17"
        entry.coordinate = CLLocationCoordinate2D(latitude: -33.906764,longitude: 18.4164983)
        entry2.title = "Truth Coffee"
        entry2.coordinate = CLLocationCoordinate2D(latitude: -33.9281976,longitude: 18.4227045)
        entry3.title = "Chop Chop Coffee"
        entry3.coordinate = CLLocationCoordinate2D(latitude: -33.9271879,longitude: 18.4327055)
        JournalEntryViewController.sharedInstance.journalEntryList.append(entry)
        JournalEntryViewController.sharedInstance.journalEntryList.append(entry2)
        JournalEntryViewController.sharedInstance.journalEntryList.append(entry3)
    }

    let titleField = UITextField(frame: CGRect(x: 20, y: 60, width: 200, height: 100))
    let notesField = UITextField(frame: CGRect(x: 20, y: 115, width: 200, height: 100))
    let xCoordinates = UITextField(frame: CGRect(x: 20, y: 175, width: 175, height: 100))
    let yCoordinates = UITextField(frame: CGRect(x: 200, y: 175, width: 175, height: 100))


    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.placeholder = "Title"
        notesField.placeholder = "Notes"
        xCoordinates.placeholder = "X-Coordinate"
        yCoordinates.placeholder = "Y-Coordinate"
        view.addSubview(titleField)
        view.addSubview(notesField)
        view.addSubview(xCoordinates)
        view.addSubview(yCoordinates)
        
        let cancelButton = UIButton(frame: CGRect(x: 20, y: 250, width: 100, height: 40))
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.titleLabel!.font = UIFont(name: "Arial", size: 15)
        cancelButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        cancelButton.backgroundColor = UIColor.orangeColor()
        cancelButton.addTarget(self, action: .cancelButton, forControlEvents: .TouchUpInside)
        
        let saveButton = UIButton(frame: CGRect(x: 200, y: 250, width: 100, height: 40))
        saveButton.setTitle("Save", forState: .Normal)
        saveButton.addTarget(self, action: .saveButton, forControlEvents: .TouchUpInside)
        saveButton.titleLabel!.font = UIFont(name: "Arial", size: 15)
        saveButton.backgroundColor = UIColor.orangeColor()
        saveButton.setTitleColor(UIColor .blueColor(), forState: .Normal)
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveButtonTapped() {
        let newEntry = JournalEntry()
        newEntry.title = titleField.text!
        newEntry.mysubtitle = notesField.text!
        newEntry.coordinate = CLLocationCoordinate2D(latitude: Double(xCoordinates.text!)!,longitude: Double(yCoordinates.text!)!)
        JournalEntryViewController.sharedInstance.journalEntryList.append(newEntry)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelButtonTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
