//
//  PhotoCell.swift
//  CoreDataTutorial
//
//  Created by James Rochabrun on 3/1/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit


class PhotoCell: UITableViewCell {
    
    
    let photoImageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return iv
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tagsLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(photoImageview)
        addSubview(authorLabel)
        addSubview(tagsLabel)
        
        photoImageview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoImageview.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        photoImageview.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        photoImageview.heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        authorLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        authorLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        authorLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        authorLabel.topAnchor.constraint(equalTo: photoImageview.bottomAnchor).isActive = true
        
        tagsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tagsLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        tagsLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tagsLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhotoCellWith(photo: Photo) {
        DispatchQueue.main.async {
            
        }
        authorLabel.text = photo.author
        tagsLabel.text = photo.tags
        if let url = photo.mediaURL {
            photoImageview.loadImage(url)
        }
    }
}



let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCacheWithURLString(_ URLString: String) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
    
    
    func loadImage(_ URLString: String) {
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}

















