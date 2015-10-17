//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Daniel Butts on 10/17/15.
//  Copyright (c) 2015 Daniel Butts. All rights reserved.
//

import UIKit


class SentMemesTableViewController: UITableViewController, UITableViewDataSource {

    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override func viewWillAppear(animated: Bool) {
        var delegate : AppDelegate {
            return (UIApplication.sharedApplication().delegate as! AppDelegate)
        }
        if let tabBar = tabBarController?.tabBar {
            tabBar.hidden = false
        }

        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes

        tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let meme = memes[indexPath.row]
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("SavedMemeDetail") as! SavedMemeDetailViewController
        detailController.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
        
        if let tabBar = tabBarController?.tabBar {
            tabBar.hidden = true
        }
        
    }
    
}
