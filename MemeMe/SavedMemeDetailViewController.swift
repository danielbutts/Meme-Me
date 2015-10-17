//
//  SavedMemeDetailViewController.swift
//  MemeMe
//
//  Created by Daniel Butts on 10/17/15.
//  Copyright (c) 2015 Daniel Butts. All rights reserved.
//

import UIKit

class SavedMemeDetailViewController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.image = meme.memedImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
