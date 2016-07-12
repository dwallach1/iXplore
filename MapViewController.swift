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

private extension Selector {
    static let addButtonTapped = #selector(MapViewController.addButtonTapped)
    static let refreshButtonTapped = #selector(MapViewController.refreshButtonTapped)
}

class MapViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    let tableView = UITableView()
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    
    //var journalEntries = JournalEntryViewController.sharedInstance.journalEntryList
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        JournalEntryViewController.sharedInstance.fillDummyArray()
        
        self.title = "iXplore"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: .addButtonTapped)
        self.navigationItem.rightBarButtonItem = addButton
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: .refreshButtonTapped)
        self.navigationItem.leftBarButtonItem = refreshButton
        
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2 + 40)
        view.addSubview(mapView)
        
        let location = CLLocationCoordinate2D(latitude: -33.906764,longitude: 18.4164983)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        mapView.zoomEnabled = true
        

        
        tableView.frame = CGRect(x: 0, y: view.frame.maxY/2 + 40, width: view.frame.width - 220, height: (view.frame.height/2))
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        mapView.delegate = self
        locationManager.delegate = self
        mapView.delegate = self
        
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
    }
    
    func refreshButtonTapped() {
        tableView.reloadData()
    }
    
    //tableView delegate protocol
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JournalEntryViewController.sharedInstance.journalEntryList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = "Entry \(indexPath.row + 1): \(JournalEntryViewController.sharedInstance.journalEntryList[indexPath.row].title!)"
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
    
    //mapview protocol
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        //Deque annotationView could be nil! We are casting as MKPinAnnotationView because we want to change the color of the pin.
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        
        if (annotationView == nil){
            //Create new annotationView
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            let label = UILabel(frame: CGRect(x:0, y:0, width: 100, height: 30))
            annotationView!.detailCalloutAccessoryView = label
    
            //Change background color of pin
            annotationView?.pinTintColor = UIColor.blackColor()
            
            var frame = annotationView!.frame
            frame.size.height = 100
            frame.size.width = 100
            annotationView!.frame = frame
            
            let theLabel = annotationView!.detailCalloutAccessoryView as! UILabel
            theLabel.text = annotation.title!
            
        }
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
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(newLocation) { placemarks, error in
            if let placemark = placemarks?.first {
                self.title = placemark.name
            }
        }
        locationManager.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
