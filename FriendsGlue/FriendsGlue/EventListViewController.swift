//
//  EventListViewController.swift
//  FriendsGlue
//
//  Created by Andres Brun Moreno on 20/05/15.
//  Copyright (c) 2015 Andres Brun Moreno. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var publicEventList: [Event] = []
    var privateEventList: [Event] = []
    
    override func viewWillAppear(animated: Bool) {
        APIClient.sharedInstance.requestSessionToken({ () -> Void in
            println("login success")
            APIClient.sharedInstance.listEvents({ (events) -> Void in
                self.privateEventList = events
                self.publicEventList = events
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()

                })
                }, failure: { (_) -> Void in
                    println("events: failure")
            })
            }, failure: { (error) -> Void in
                println("login failure \(error)")
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventTableViewCell") as! EventTableViewCell
        
        let currentEvent = currentList()[indexPath.row]
        cell.locationLabel.text = currentEvent.locationName
        cell.activityLabel.text = currentEvent.verb
        cell.peopleCountLabel.text = "\(currentEvent.friends.count) friends"
        
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        cell.timeLabel.text = formatter.stringFromDate(currentEvent.date ?? NSDate())
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let actionSheet = UIActionSheet(title: "I want to...", delegate: self, cancelButtonTitle: "Dismiss", destructiveButtonTitle: "Meh, nope", otherButtonTitles: "Yeah, I am in!")
        actionSheet.showInView(view)
        
        return false
    }
    
    @IBAction func segmentControlChanged(sender: AnyObject) {
        tableView.reloadData()
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        // API call to update status
    }
    
    func currentList() -> [Event] {
        return segmentedControl.selectedSegmentIndex == 0 ? privateEventList : publicEventList
    }
}
