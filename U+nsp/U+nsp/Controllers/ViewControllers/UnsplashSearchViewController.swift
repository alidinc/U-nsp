//
//  UnsplashSearchViewController.swift
//  U+nsp
//
//  Created by Ali Dinç on 06/08/2021.
//

import UIKit

class UnsplashSearchViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var unsplashImages = [UnsplashImage]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        searchBar.searchTextField.textColor = .white
        
        searchForImages(with: "bike")
    }

    // MARK: - Methods
    
    func searchForImages(with searchTerm: String) {
        UnsplashController.fetchUnsplashImages(with: searchTerm) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let unsplashImages):
                    self.unsplashImages = unsplashImages
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension UnsplashSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unsplashImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "unsplashCell", for: indexPath) as? UnsplashImageTableViewCell else { return UITableViewCell() }
        cell.unsplashImage = unsplashImages[indexPath.row]
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension UnsplashSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        searchForImages(with: searchTerm)
    }
}
