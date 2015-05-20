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
    
    var publicEventList: [Event] = [
        Event.createEvent("Play football", locationName: "MauerPark", latitude: nil, longitude: nil, date: NSDate().dateByAddingTimeInterval(3600*24*3), friends: []),
        Event.createEvent("Drink a beer", locationName: "Mitte", latitude: nil, longitude: nil, date: NSDate().dateByAddingTimeInterval(3600*24*1), friends: []),
        Event.createEvent("Go to the cinema", locationName: "Sony Center", latitude: nil, longitude: nil, date: NSDate().dateByAddingTimeInterval(3600*24*5), friends: []),
        Event.createEvent("Watch a match", locationName: "Colisseum", latitude: nil, longitude: nil, date: NSDate().dateByAddingTimeInterval(3600*24*10), friends: []),
        Event.createEvent("Go to the cinema", locationName: "Sony Center", latitude: nil, longitude: nil, date: NSDate().dateByAddingTimeInterval(3600*24*5), friends: []),
        Event.createEvent("Watch a match", locationName: "At the bar", latitude: nil, longitude: nil, date: NSDate().dateByAddingTimeInterval(3600*24*10), friends: []),
        Event.createEvent("Drink a beer", locationName: "Mitte", latitude: nil, longitude: nil, date: NSDate().dateByAddingTimeInterval(3600*24*1), friends: [])
    ]
    var privateEventList: [Event] = [
        Event.createEvent("Play football", locationName: "MauerPark", latitude: nil, longitude: nil, date: NSDate().dateByAddingTimeInterval(3600*24*3), friends: []),
        Event.createEvent("Go to the cinema", locationName: "Sony Center", latitude: nil, longitude: nil, date: NSDate().dateByAddingTimeInterval(3600*24*5), friends: []),
        Event.createEvent("Watch a match", locationName: "At the bar", latitude: nil, longitude: nil, date: NSDate().dateByAddingTimeInterval(3600*24*10), friends: []),
        Event.createEvent("Drink a beer", locationName: "Mitte", latitude: nil, longitude: nil, date: NSDate().dateByAddingTimeInterval(3600*24*1), friends: [])
    ]
    
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
//        cell.peopleCountLabel.text = "\(currentEvent.friends.count) friends"
        cell.peopleCountLabel.text = "\(Int(arc4random_uniform(7)+1)) friends"
        
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        cell.timeLabel.text = formatter.stringFromDate(currentEvent.date!)
        
        
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
