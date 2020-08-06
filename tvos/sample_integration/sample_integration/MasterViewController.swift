//
//  MasterViewController.swift
//  sample_integration
//
//  Created by Juan Pablo on 30/07/2020.
//  Copyright © 2020 Embrace.io. All rights reserved.
//

import UIKit
import Embrace

// EMBRACE HINT:
// Storing constants like moment or breadcrumb names in a String extension keeps them out of the global namespace
// while also making typos less likely.
fileprivate extension String {
   static var addItemMomentName: String { "embrace_add_item" }
   static var removeItemMomentName: String { "embrace_remove_item" }
}

class MasterViewController: UITableViewController {

    var objects = [Date]()
    var waitingForReload = false
    
    // EMBRACE HINT:
    // Embrace will automatically capture class names for views.  Sometimes that's what you want,
    // other times it is better to customize the name of a view.  This is especially important if
    // the view's class is used in many places inside your app.
    // Implementing this method, including the @objc tag so embrace can call it, allows you to customize the name.
    @objc public func embName() -> String {
        return "Custom Named View"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem

        // initialize the navigation bar item
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(insertNewObject(_:)))
        
        // set the item to the navigation bar
        navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // EMBRACE HINT:
        // Event logging is how you can ensure that events are available in alerts as they happen, rather than when sessions end.
        // If you are tracking down a difficult bug, or trying to understand a complex interaction -- logging is an appropriate API to use
        // For lighter weight tracking like navigation events, look into breadcrumbs.
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            // EMBRACE HINT:
            // When you use logging events, these are immediately sent to our servers and are meant to be the basis for alerting you to
            // real-time issues with your application in production.  As such, take care not to over-use logging events as they have a higher impact
            // on the performance of your app vs breadcrumbs.
            // In this example, we are trying to understand loading issues in our application.  Users are saying that often the app hangs, failing to
            // load the homescreen, leaving the user with a blank screen.  We're adding a log here to track that.
            // Note that our log is a complex object, not a simple string.  By breaking out properties like this we can use their values to power
            // our alerting, we can also search and filter on the property values -- we cannot do that if we only send strings.
            // Taking a screenshot is way to see what the user was looking at yourself.  Consider the users privacy and the impact on performance
            // when enabling this feature.
            let properties = [
                "property_a": "value_a",
                "property_b": "value_b"]
            
            Embrace.sharedInstance().logMessage("Loading not finished in time.",
                                                with: .error,
                                                properties: properties,
                                                takeScreenshot: true)
        }
        if let splitVC = splitViewController {
           clearsSelectionOnViewWillAppear = splitVC.isCollapsed
        }
        
        super.viewWillAppear(animated)
    }
    
    @objc
    func insertNewObject(_ sender: Any) {
        // EMBRACE HINT:
        // Moments are a great way to measure the performance and abandonment of workflows within your application
        // Here we are inserting a new item into our table view.  The moment is wrapping that action so we can
        // Understand how our database and animation performance is working during this process.
        // Note the waitingForReload boolean used later in cellForRowAt to end the moment
        // Always make sure to end moments you start, Embrace considered any non-ended moment to be an abandonment by the user
        waitingForReload = true
        Embrace.sharedInstance().startMoment(withName: .addItemMomentName)
        objects.insert(Date(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let object = objects[indexPath.row]
            let controller = segue.destination as! DetailViewController
            // EMBRACE HINT:
            // Embrace has two options for logging events, breadcrumbs and logs.  This is an example of breadcrumb.
            // Breadcrumbs are lightweight items that add little overhead to your application
            // Use them to track branching and state changes that are relevant to the session but not urgent for alerting.
            let msg = "Navigating to detail page for: \(object)"
            Embrace.sharedInstance().logBreadcrumb(withMessage: msg)
            controller.detailItem = object
        }
    }

    // MARK: - Table View

    override func setEditing(_ editing: Bool, animated: Bool) {
        let msg = "Master table view editing mode did change to: \(editing), animated: \(animated)"
        Embrace.sharedInstance().logBreadcrumb(withMessage: msg)
        super.setEditing(editing, animated: animated);
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { objects.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get the cell for this index path
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // typecast the object
        let object = objects[indexPath.row]
        
        // set the cell's label with the object's description
        cell.textLabel?.text = object.description
        
        // if the table is waiting to reload
        guard waitingForReload else { return cell }
        
        // toggle the flag off
        waitingForReload.toggle()
        
        // EMBRACE HINT:
        // This is where we end our add item moment.  We wanted to measure this interaction as it is core to our user experience.
        // By measuring user interactions in this manner you can start to understand how app performance impacts your user journey.
        Embrace.sharedInstance().endMoment(withName: .addItemMomentName)
        
        // return the cell
        return cell
    }

    // Return false if you do not want the specified item to be editable.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            
            objects.remove(at: indexPath.row)
            
            // EMBRACE HINT:
            // This is where we are measuring our remove item workflow.  We wrap the animation with a moment to try
            // to understand the performance of this operation as our users will do it often.
            // Notice how we're wrapping the call with performBatchUpdates.  This is because we want to measure to true
            // performance of this operation so we need a callback for when it completes.
            
            // log the beginning of the event
            Embrace
                .sharedInstance()
                .logBreadcrumb(withMessage: "starting remove item moment")
            
            // initiate the moment with embrace
            Embrace
                .sharedInstance()
                .startMoment(withName: .removeItemMomentName)
            
            // update the table view
            tableView.performBatchUpdates({
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            
            }, completion: {_ in
                
                // log the end of the event
                Embrace
                    .sharedInstance()
                    .logBreadcrumb(withMessage: "ending remove item moment");
                
                // end the moment
                Embrace
                    .sharedInstance()
                    .endMoment(withName: .removeItemMomentName)
            })
           
        case .none: break
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        case .insert: break
        @unknown default: break
        }
    }
}
