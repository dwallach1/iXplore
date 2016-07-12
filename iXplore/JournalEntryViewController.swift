//
//  JournalEntryViewController.swift
//  iXplore
//
//  Created by David Wallach on 7/11/16.
//  Copyright © 2016 David Wallach. All rights reserved.
//

import UIKit
import MapKit

class JournalEntry: NSObject, MKAnnotation, NSCoding {
    var title: String? = "hello"
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var mysubtitle: String?
    var date: NSDate?
    var image: UIImage?
    
    override required init ()
    {
        
    }
    required init? (coder: NSCoder){
        title = coder.decodeObjectForKey("title") as? String
        coordinate.latitude = (coder.decodeDoubleForKey("coordinateLat"))
        coordinate.longitude = (coder.decodeDoubleForKey("coordinateLong"))
        mysubtitle = coder.decodeObjectForKey("mysubtitle") as? String
        date = coder.decodeObjectForKey("date") as? NSDate
        image = coder.decodeObjectForKey("image") as? UIImage
    }
    
    func encodeWithCoder(coder: NSCoder){
        coder.encodeObject(title, forKey: "title")
        coder.encodeDouble(coordinate.latitude, forKey: "coordinateLat")
        coder.encodeDouble(coordinate.longitude, forKey: "coordinateLong")
        coder.encodeObject(mysubtitle, forKey: "mysubtitle")
        coder.encodeObject(date, forKey: "date")
        coder.encodeObject(image, forKey: "image")
    }
}

class JournalEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static var sharedInstance = JournalEntryViewController()
    var journalEntryList: [JournalEntry] = [JournalEntry]()
    let imagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var xCoordinatesField: UITextField!
    @IBOutlet weak var yCoordinatesField: UITextField!
    
    
    
//    func fillDummyArray() {
//        let entry = JournalEntry()
//        let entry2 = JournalEntry()
//        let entry3 = JournalEntry()
//        entry.title = "Workshop 17"
//        entry.coordinate = CLLocationCoordinate2D(latitude: -33.906764,longitude: 18.4164983)
//        entry2.title = "Truth Coffee"
//        entry2.coordinate = CLLocationCoordinate2D(latitude: -33.9281976,longitude: 18.4227045)
//        entry3.title = "Chop Chop Coffee"
//        entry3.coordinate = CLLocationCoordinate2D(latitude: -33.9271879,longitude: 18.4327055)
//        JournalEntryViewController.sharedInstance.journalEntryList.append(entry)
//        JournalEntryViewController.sharedInstance.journalEntryList.append(entry2)
//        JournalEntryViewController.sharedInstance.journalEntryList.append(entry3)
//    }

//    let titleField = UITextField(frame: CGRect(x: 20, y: 60, width: 200, height: 100))
//    let notesField = UITextField(frame: CGRect(x: 20, y: 115, width: 200, height: 100))
//    let xCoordinates = UITextField(frame: CGRect(x: 20, y: 175, width: 175, height: 100))
//    let yCoordinates = UITextField(frame: CGRect(x: 200, y: 175, width: 175, height: 100))


    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
//        titleField.placeholder = "Title"
//        notesField.placeholder = "Notes"
//        xCoordinates.placeholder = "X-Coordinate"
//        yCoordinates.placeholder = "Y-Coordinate"
//        view.addSubview(titleField)
//        view.addSubview(notesField)
//        view.addSubview(xCoordinates)
//        view.addSubview(yCoordinates)
//        
//        let cancelButton = UIButton(frame: CGRect(x: 20, y: 250, width: 100, height: 40))
//        cancelButton.setTitle("Cancel", forState: .Normal)
//        cancelButton.titleLabel!.font = UIFont(name: "Arial", size: 15)
//        cancelButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
//        cancelButton.backgroundColor = UIColor.orangeColor()
//        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), forControlEvents: .TouchUpInside)
//        
//        let saveButton = UIButton(frame: CGRect(x: 200, y: 250, width: 100, height: 40))
//        saveButton.setTitle("Save", forState: .Normal)
//        saveButton.addTarget(self, action: #selector(saveButtonTapped), forControlEvents: .TouchUpInside)
//        saveButton.titleLabel!.font = UIFont(name: "Arial", size: 15)
//        saveButton.backgroundColor = UIColor.orangeColor()
//        saveButton.setTitleColor(UIColor .blueColor(), forState: .Normal)
//        view.addSubview(cancelButton)
//        view.addSubview(saveButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func saveButtonTapped() {
//        let manager = NSFileManager.defaultManager()
//        let documents = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
//        let fileURL = documents.URLByAppendingPathComponent("journalEntries.txt")
//        
//        let newEntry = JournalEntry()
//        newEntry.title = titleField.text!
//        newEntry.mysubtitle = notesField.text!
//        newEntry.coordinate = CLLocationCoordinate2D(latitude: Double(xCoordinates.text!)!,longitude: Double(yCoordinates.text!)!)
//        JournalEntryViewController.sharedInstance.journalEntryList.append(newEntry)
//        NSKeyedArchiver.archiveRootObject(newEntry, toFile: fileURL.path!)
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        let manager = NSFileManager.defaultManager()
        let documents = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documents.URLByAppendingPathComponent("journalEntries.txt")
        
        let newEntry = JournalEntry()
        newEntry.title = titleField.text!
        newEntry.mysubtitle = notesField.text!
        newEntry.coordinate = CLLocationCoordinate2D(latitude: Double(xCoordinatesField.text!)!,longitude: Double(yCoordinatesField.text!)!)
        newEntry.image = imageView.image
        JournalEntryViewController.sharedInstance.journalEntryList.append(newEntry)
        NSKeyedArchiver.archiveRootObject(newEntry, toFile: fileURL.path!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func cancelButtonTapped() {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /********** Adding image to profile **********/
    
    @IBAction func addPhotoButtonTapped(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        if let pickedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
