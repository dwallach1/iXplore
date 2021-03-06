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
    
    static var list: [JournalEntry] = {
        let manager = NSFileManager.defaultManager()
        let documents = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documents.URLByAppendingPathComponent("journalEntries.txt")
        if let entryArray = NSKeyedUnarchiver.unarchiveObjectWithFile(fileURL.path!) as? [JournalEntry] {
            return entryArray
        } else {
            return []
        }
    }()
    
    var title: String? = "Journal Entry"
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var notes: String?    
    var date: String?
    var image: UIImage?
    
    init(title: String, notes: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.notes = notes
        self.coordinate = coordinate
    }
    
    required init? (coder: NSCoder){
        title = coder.decodeObjectForKey("title") as? String
        coordinate.latitude = (coder.decodeDoubleForKey("coordinateLat"))
        coordinate.longitude = (coder.decodeDoubleForKey("coordinateLong"))
        notes = coder.decodeObjectForKey("notes") as? String
        date =  coder.decodeObjectForKey("date") as? String
        image = coder.decodeObjectForKey("image") as? UIImage
    }
    
    func encodeWithCoder(coder: NSCoder){
        coder.encodeObject(title, forKey: "title")
        coder.encodeDouble(coordinate.latitude, forKey: "coordinateLat")
        coder.encodeDouble(coordinate.longitude, forKey: "coordinateLong")
        coder.encodeObject(notes, forKey: "notes")
        coder.encodeObject(date, forKey: "date")
        coder.encodeObject(image, forKey: "image")
    }
}

class JournalEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    //Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var xCoordinatesField: UITextField!
    @IBOutlet weak var yCoordinatesField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        addPhotoButton.layer.cornerRadius = 4
        cancelButton.layer.cornerRadius = 4
        saveButton.layer.cornerRadius = 4
        
        let toolBar = UIToolbar().ToolbarPiker(#selector(JournalEntryViewController.dismissPicker))
        dateField.inputAccessoryView = toolBar
        titleField.inputAccessoryView = toolBar
        notesField.inputAccessoryView = toolBar
    }
    
    func dismissPicker() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        let manager = NSFileManager.defaultManager()
        let documents = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documents.URLByAppendingPathComponent("journalEntries.txt")
        
        let newEntry = JournalEntry(title: titleField.text!, notes: notesField.text!, coordinate: CLLocationCoordinate2D(latitude: Double(xCoordinatesField.text!)!,longitude: Double(yCoordinatesField.text!)!))
        newEntry.image = imageView.image
        newEntry.date = dateField.text!
        JournalEntry.list.append(newEntry)
        NSKeyedArchiver.archiveRootObject(JournalEntry.list, toFile: fileURL.path!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
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
