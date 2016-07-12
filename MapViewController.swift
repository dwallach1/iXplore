//
//  MapViewViewController.swift
//  iXplore
//
//  Created by David Wallach on 7/11/16.
//  Copyright © 2016 David Wallach. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    let tableView = UITableView()
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = NSFileManager.defaultManager()
        let documents = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documents.URLByAppendingPathComponent("journalEntries.txt")
        let path = fileURL.path
        
        if let entry = NSKeyedUnarchiver.unarchiveObjectWithFile(fileURL.path!) as? JournalEntry {
            JournalEntryViewController.sharedInstance.journalEntryList.append(entry)
        }
        
        self.title = "iXplore"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addButton
        
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2 + 100)
        view.addSubview(mapView)
        
        let location = CLLocationCoordinate2D(latitude: -33.906764,longitude: 18.4164983)
        let span = MKCoordinateSpanMake(0.07, 0.07)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        mapView.zoomEnabled = true
        mapView.showsUserLocation = true
        mapView.tintColor = UIColor.redColor()
    
        
        tableView.frame = CGRect(x: 0, y: view.frame.maxY/2 + 100, width: view.frame.width - 220, height: (view.frame.height/2))
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.registerNib(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "entryCell")
        tableView.rowHeight = 88
        
        tableView.dataSource = self
        tableView.delegate = self
        mapView.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = 100
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
        mapView.addAnnotations(JournalEntryViewController.sharedInstance.journalEntryList)
    }
    
    func addButtonTapped() {
        let journalEntryVC = JournalEntryViewController(nibName: "JournalEntryViewController", bundle: nil)
        presentViewController(journalEntryVC, animated: true, completion: nil)
        locationManager.stopUpdatingLocation()
    }
    
    
    /******** Table View **************/
    
    //tableView delegate protocol
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JournalEntryViewController.sharedInstance.journalEntryList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let currentEntry = JournalEntryViewController.sharedInstance.journalEntryList
        let cell = tableView.dequeueReusableCellWithIdentifier("entryCell", forIndexPath: indexPath) as! UserTableViewCell
        cell.titleLabel.text = "\(currentEntry[indexPath.row].title!)"
        cell.dateLabel.text = "\(currentEntry[indexPath.row].title!)"
        cell.photoView.image = currentEntry[indexPath.row].image
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            JournalEntryViewController.sharedInstance.journalEntryList.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let location = CLLocationCoordinate2D(latitude: JournalEntryViewController.sharedInstance.journalEntryList[indexPath.row].coordinate.latitude,longitude: JournalEntryViewController.sharedInstance.journalEntryList[indexPath.row].coordinate.longitude)
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    /******* Map View **************/
    
    //mapview protocol
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        let identifier = "MyPin"
        //Deque annotationView could be nil! We are casting as MKPinAnnotationView because we want to change the color of the pin.
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        
        if (annotationView == nil){
            //Create new annotationView
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
//            let label = UILabel(frame: CGRect(x:0, y:0, width: 100, height: 30))
//            annotationView!.detailCalloutAccessoryView = label
    
            //Change background color of pin
            annotationView?.pinTintColor = UIColor.greenColor()
            
            var frame = annotationView!.frame
            frame.size.height = 100
            frame.size.width = 100
            annotationView!.frame = frame
            
        }
        
//        let theLabel = annotationView!.detailCalloutAccessoryView as! UILabel
//        theLabel.text = annotation.title!
        return annotationView
    }
    
    //location manager protocol
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .Denied {
            let alert = UIAlertController(title: "You have chosen not to share your location", message: "Certain functions of this application will be limited, please go into settings to reconfigure", preferredStyle: .Alert)
            let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
            alert.addAction(dismiss)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(newLocation) { placemarks, error in
//            if let placemark = placemarks?.first {
//                self.title = placemark.name
//            }
//        }
        locationManager.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
