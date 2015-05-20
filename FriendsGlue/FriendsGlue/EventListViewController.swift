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
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.tintColor = UIColor.cDarkBlue()
        self.tableView.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject)
    {
        APIClient.sharedInstance.requestSessionToken({ () -> Void in
            println("login success")
            APIClient.sharedInstance.listEvents({ (events) -> Void in
                self.privateEventList = events
                self.publicEventList = events
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    
                })
                }, failure: { (_) -> Void in
                    println("events: failure")
                    self.refreshControl.endRefreshing()
            })
            }, failure: { (error) -> Void in
                println("login failure \(error)")
                self.refreshControl.endRefreshing()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
       super.viewWillAppear(animated)
        
        refresh(self)
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
//        cell.peopleCountLabel.text = "\(currentEvent.friends.count) friends"
        cell.peopleCountLabel.text = "\(Int(arc4random_uniform(7)+1)) friends"
        
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .NoStyle
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
