//
//  ViewController.swift
//  Wikimovie
//
//  Created by Yüksel Ağgöz on 31.10.2020.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var switchGridListButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    var movies = [Movie]()
    var pageNumber = 1
    var movieId = 0
    var isGridView = true
    var filterText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pageNumber = 1
        let service = Service()
        service.getMovies(endPoint: "popular", page: pageNumber)
        service.completionHandler { (movies, status, message) in
            if status {
                self.movies = movies!
                self.collectionView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetail" {
            if let destination = segue.destination as? DetailTableViewController {
                destination.movieId = self.movieId
            }
        }
    }
    
    @IBAction func switchGridListTouched(_ sender: Any) {
        isGridView = !isGridView
        if isGridView {
            switchGridListButton.title = "List"
        }
        else {
            switchGridListButton.title = "Grid"
        }
        self.collectionView.reloadData()
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.movieId = self.movies[indexPath.item].movieId!
        performSegue(withIdentifier: "segueToDetail", sender: nil)
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.item]
        let isFavoriteMovie = Utility().isFavoriteMovie(movieId: movie.movieId!)
        
        if isGridView {
            cell.configure(withImagePath: movie.posterPath, andTitle: movie.title, isFavorite: isFavoriteMovie)
        }
        else {
            cell.configure(withImagePath: movie.backdropPath, andTitle: movie.title, isFavorite: isFavoriteMovie)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MovieListHeaderView", for: indexPath)
            let searchBar = headerView.viewWithTag(1) as! UISearchBar
            searchBar.delegate = self
            return headerView
            
        }
        else if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MovieListFooterView", for: indexPath)
            let loadMoreButton = footerView.viewWithTag(1) as! UIButton
            loadMoreButton.addTarget(self, action: #selector(loadMoreButtonTouched), for: .touchUpInside)
            loadMoreButton.isHidden = filterText == "" ? false : true
            return footerView

        }
        else {
            return UICollectionReusableView()
        }
    }
    
    @objc func loadMoreButtonTouched() {
        pageNumber += 1
        let service = Service()
        service.getMovies(endPoint: "popular", page: pageNumber)
        service.completionHandler { (movies, status, message) in
            if status {
                let newIndexPath = IndexPath(item: self.movies.count, section: 0)
                self.movies.append(contentsOf: movies!)
                self.collectionView.insertItems(at: [newIndexPath])
            }
        }
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = (self.view.bounds.size.width - 20)
        var height = width * 113 / 200
        if isGridView {
            width = (self.view.bounds.size.width - 30) / 2
            height = width * 3 / 2
        }
        
        return CGSize(width: width, height: height)
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text!.count < 3) {
            let alert = UIAlertController(title: "Opps!", message: "Enter at least three characters.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in

            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            filterText = searchBar.text!
            var filteredMovies = [Movie]()
            for movie in self.movies {
                if movie.originalTitle!.lowercased().contains(searchBar.text!.lowercased()) {
                    filteredMovies.append(movie)
                }
            }
            self.movies = filteredMovies
            self.collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        filterText = searchBar.text!
        pageNumber = 1
        
        let service = Service()
        service.getMovies(endPoint: "popular", page: pageNumber)
        service.completionHandler { (movies, status, message) in
            if status {
                self.movies = movies!
                self.collectionView.reloadData()
            }
        }
    }
}
