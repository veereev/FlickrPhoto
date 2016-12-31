//
//  File.swift
//  FlickrPhoto
//
//  Created by VEERASEKHAR ADDEPALLI on 25/12/16.
//  Copyright © 2016 VEERASEKHAR ADDEPALLI. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell : UICollectionViewCell
{
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    func update(with image:UIImage?)
    {
        if let imageToDisplay = image
        {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
            
        }
        else
        {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        update(with: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        update(with: nil)
    }
    
}
