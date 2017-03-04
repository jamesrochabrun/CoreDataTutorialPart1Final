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
        iv.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        //label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let tagsLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        //label.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dividerLineView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = false
        
        addSubview(photoImageview)
        addSubview(authorLabel)
        addSubview(tagsLabel)
        addSubview(dividerLineView)
        
        photoImageview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoImageview.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        photoImageview.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        photoImageview.heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        authorLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        authorLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
        authorLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
        authorLabel.topAnchor.constraint(equalTo: photoImageview.bottomAnchor).isActive = true
        
        dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerLineView.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
        dividerLineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
        dividerLineView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor).isActive = true
        
        tagsLabel.heightAnchor.constraint(equalToConstant: 69).isActive = true
        tagsLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
        tagsLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
        tagsLabel.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhotoCellWith(photo: Photo) {
        
        DispatchQueue.main.async {
            self.authorLabel.text = photo.author
            self.tagsLabel.text = photo.tags
            if let url = photo.mediaURL {
                self.photoImageview.loadImageUsingCacheWithURLString(url, placeHolder: #imageLiteral(resourceName: "placeholder"))
            }
        }
    }
}



let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCacheWithURLString(_ URLString: String, placeHolder: UIImage) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(error)")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
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

















