//
//  PhotosGalleryViewController.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/31/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit
import Photos

class PhotosGalleryViewController: UICollectionViewController {
    
    
    var videoAsset: AVAsset? = nil
    weak var delegate: PhotosGalleryDelegate? = nil
    var imageToSend: UIImage?
    let grayOutView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.alpha = 0.0
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red:0.26, green:0.64, blue:0.96, alpha:1.0)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0.0
        return button
    }()
    
    var photos: PHFetchResult<PHAsset>
    private lazy var imageManager = PHCachingImageManager()

    static func loadPhotos(isPhotoSelector: Bool) -> PHFetchResult<PHAsset> {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        if isPhotoSelector {
            return PHAsset.fetchAssets(with: allPhotosOptions)
        } else {
            return PHAsset.fetchAssets(with: .video, options: allPhotosOptions)
        }
    }
    
    private lazy var thumbnailSize: CGSize = {
        return CGSize(width: 240, height: 240)
    }()
    
    let isPhotoSelector: Bool
    
    init(collectionViewLayout layout: UICollectionViewLayout, isPhotoSelector: Bool) {
        
        self.isPhotoSelector = isPhotoSelector
        
        photos = PhotosGalleryViewController.loadPhotos(isPhotoSelector: isPhotoSelector)
        
        super.init(collectionViewLayout: layout)
        self.title = isPhotoSelector ? "Photos" : "Videos"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        grayOutView.frame = self.view.frame
        
        self.collectionView?.backgroundColor = .white
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "Photo Cell")
        
        [grayOutView, imageView, submitButton].forEach { view.addSubview($0) }
        
        submitButton.addTarget(self, action: #selector(tappedSend), for: .touchUpInside)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let asset = photos.object(at: indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo Cell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.representedIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            if cell.representedIdentifier == asset.localIdentifier {
                cell.imageView.image = image
            }
        })
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = photos.object(at: indexPath.item)
        
   
        if !isPhotoSelector {
            imageManager.requestAVAsset(forVideo: asset, options: nil) { (asset, audioMix, info) in
                guard let safeAsset = asset else { return }
                self.videoAsset = safeAsset
            }
        }
        
        
        imageManager.requestImage(for: asset, targetSize: view.frame.size, contentMode: .aspectFill, options: nil, resultHandler:
            {  image, info in
                guard let image = image, let info = info else { return }
                if let isThumbnail = info[PHImageResultIsDegradedKey as NSString] as? Bool, !isThumbnail {
                    
        
                    self.imageView.image = image
                    self.layoutImage(image: image)
                   
                    UIView.animate(withDuration: 0.2, animations: {
                        self.grayOutView.alpha = 0.7
                        self.imageView.alpha = 1.0
                        self.submitButton.alpha = 1.0
                    })
                    
                    self.imageToSend = image
                }
        })
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let imageWidth = (self.view.frame.width - 6)/4
        
        return CGSize(width: imageWidth, height: imageWidth)
    }
    
    func layoutImage(image: UIImage) {
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        let ratio = image.size.height/image.size.width
        print(ratio)
        
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: ratio).isActive = true
        
        
        submitButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func tappedSend() {
        
        
        if isPhotoSelector {
            if let image = imageToSend {
                self.delegate?.selectedPhoto(image: image)
            }
        } else {
            if let image = imageToSend, let videoAsset = videoAsset {
                self.delegate?.selectedVideo(video: videoAsset, image: image)
            }
        }
        
         self.navigationController?.popViewController(animated: true)
    }
}

extension PhotosGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

protocol PhotosGalleryDelegate: class {
    func selectedPhoto(image: UIImage)
    func selectedVideo(video: AVAsset, image: UIImage)
}
