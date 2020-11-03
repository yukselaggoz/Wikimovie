//
//  DetailTableViewController.swift
//  Wikimovie
//
//  Created by Yüksel Ağgöz on 3.11.2020.
//

import UIKit
import Alamofire

class DetailTableViewController: UITableViewController {
    
    @IBOutlet weak var favoriteMovieButton: UIBarButtonItem!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    var movie = Movie()
    var movieId: Int? = nil
    var isFavoriteMovie = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service = Service()
        service.getMovieDetail(movieId: "\(self.movieId!)")
        service.completionHandlerMovieDetail { (movie, status, message) in
            if status {
                self.movie = movie!
                AF.request(Service.baseImageUrl + self.movie.backdropPath!, method: .get).response { response in
                    switch response.result {
                    case .success(let responseData):
                        self.posterImageView.image = UIImage(data: responseData!, scale:1)
                    case .failure(let error):
                        print("error--->",error)
                    }
                }
                self.titleLabel.text = self.movie.originalTitle
                self.voteLabel.text = "Vote: \(self.movie.voteAvarage!)"
                self.descriptionLabel.text = self.movie.overview
                self.descriptionLabel.sizeToFit()
                self.dateLabel.text = self.movie.releaseDate
                self.tableView.reloadData()
            }
        }
        self.isFavoriteMovie = Utility().isFavoriteMovie(movieId: self.movieId!)
        if isFavoriteMovie {
            self.favoriteMovieButton.image = UIImage(named: "ic_star")
        }
        else {
            self.favoriteMovieButton.image = UIImage(named: "ic_star_empty")
        }
    }

    @IBAction func favoriteButtonTouched(_ sender: Any) {
        isFavoriteMovie = !isFavoriteMovie
        if isFavoriteMovie {
            Utility().addToFavoriteMovies(movieId: self.movieId!)
            self.favoriteMovieButton.image = UIImage(named: "ic_star")
        }
        else {
            Utility().removeFromFavoriteMovies(movieId: self.movieId!)
            self.favoriteMovieButton.image = UIImage(named: "ic_star_empty")
        }
    }
}
