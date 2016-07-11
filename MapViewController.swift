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
}

class MapViewController: UIViewController {
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "iXplore"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: .addButtonTapped)
        self.navigationItem.rightBarButtonItem = addButton
        

        let mapView = MKMapView()
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2 + 40)
        view.addSubview(mapView)
        
        let location = CLLocationCoordinate2D(latitude: -33.906764,longitude: 18.4164983)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        mapView.zoomEnabled = true
        
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: view.frame.maxY/2 + 40, width: view.frame.width, height: (view.frame.height / 2))
        view.addSubview(tableView)
    }
    
    func addButtonTapped() {
        let journalEntryVC = JournalEntryViewController(nibName: "JournalEntryViewController", bundle: nil)
        navigationController?.pushViewController(journalEntryVC, animated: true)
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
