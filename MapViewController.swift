//
//  MapViewViewController.swift
//  iXplore
//
//  Created by David Wallach on 7/11/16.
//  Copyright © 2016 David Wallach. All rights reserved.
//

import UIKit
import MapKit

private extension Selector {
    static let addButtonTapped = #selector(MapViewController.addButtonTapped)
    static let refreshButtonTapped = #selector(MapViewController.refreshButtonTapped)
}

class MapViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    let mapView = MKMapView()
    

    var journalEntriesArray: [JournalEntry] = [JournalEntry]()

    let entry = JournalEntry()
    let entry2 = JournalEntry()
    let entry3 = JournalEntry()
    
    
//    func entryList() -> [JournalEntry] {
//        
//        let entry = JournalEntry()
//        entry.title = "Workshop 17"
//        entry.coordinate = CLLocationCoordinate2D(latitude: -33.906764,longitude: 18.4164983)
//        
//        let entry2 = JournalEntry()
//        entry2.title = "Truth Coffee"
//        entry2.coordinate = CLLocationCoordinate2D(latitude: -33.9281976,longitude: 18.4227045)
//        
//        let entry3 = JournalEntry()
//        entry3.title = "Chop Chop Coffee"
//        entry3.coordinate = CLLocationCoordinate2D(latitude: -33.9271879,longitude: 18.4327055)
//        
//        return [entry,entry2, entry3]
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entry.title = "Workshop 17"
        entry.coordinate = CLLocationCoordinate2D(latitude: -33.906764,longitude: 18.4164983)
        entry2.title = "Truth Coffee"
        entry2.coordinate = CLLocationCoordinate2D(latitude: -33.9281976,longitude: 18.4227045)
        entry3.title = "Chop Chop Coffee"
        entry3.coordinate = CLLocationCoordinate2D(latitude: -33.9271879,longitude: 18.4327055)
    
        journalEntriesArray.append(entry)
        journalEntriesArray.append(entry2)
        journalEntriesArray.append(entry3)
        
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
        
        mapView.delegate = self
        mapView.addAnnotations(journalEntriesArray)
        
        tableView.frame = CGRect(x: 0, y: view.frame.maxY/2 + 40, width: view.frame.width, height: (view.frame.height / 2))
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func addButtonTapped() {
        let journalEntryVC = JournalEntryViewController(nibName: "JournalEntryViewController", bundle: nil)
        navigationController?.pushViewController(journalEntryVC, animated: true)
        tableView.reloadData()
    }
    
    func refreshButtonTapped() {
        tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journalEntriesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = "Entry: \(journalEntriesArray[indexPath.row].title!)"
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            journalEntriesArray.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("\(journalEntriesArray[indexPath.row].title)")
        let location = CLLocationCoordinate2D(latitude: journalEntriesArray[indexPath.row].coordinate.latitude,longitude: journalEntriesArray[indexPath.row].coordinate.longitude)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
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
            theLabel.text = "\(annotation.title!)"
            
        }
        
        return annotationView
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
