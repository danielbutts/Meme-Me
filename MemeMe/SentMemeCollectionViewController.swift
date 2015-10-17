//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Daniel Butts on 10/17/15.
//  Copyright (c) 2015 Daniel Butts. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var topNavigationBar: UINavigationItem!
    
    var memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 2.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension,height: dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let tabBar = tabBarController?.tabBar {
            tabBar.hidden = false
        }

        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
        collectionView!.reloadData()
    }
    
    // MARK: Collection View Data Source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        cell.memeImageView?.image = meme.memedImage
        cell.backgroundView?.backgroundColor = UIColor.whiteColor()
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("SavedMemeDetail") as! SavedMemeDetailViewController
        detailController.meme = memes[indexPath.row]
        
        navigationController!.pushViewController(detailController, animated: true)
        
        if let tabBar = tabBarController?.tabBar {
            tabBar.hidden = true
        }
    }
    
}
