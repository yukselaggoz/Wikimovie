//
//  MovieCollectionViewCell.swift
//  Wikimovie
//
//  Created by Yüksel Ağgöz on 2.11.2020.
//

import UIKit
import Alamofire

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet var label: UILabel!
    
    static let identifier = "MovieCollectionViewCell"
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(withImagePath imagePath: String?, andTitle title: String?, isFavorite favorite: Bool?) {
        AF.request(Service.baseImageUrl + imagePath!, method: .get).response { response in
            switch response.result {
                case .success(let responseData):
                    self.imageView.image = UIImage(data: responseData!, scale:1)

                case .failure(let error):
                    print("error--->",error)
                }
        }
        
        self.label.text = title
        
        if favorite! {
            self.starImageView.image = UIImage(named: "ic_star")
        }
        else {
            self.starImageView.image = UIImage()
        }
    }
    
}
