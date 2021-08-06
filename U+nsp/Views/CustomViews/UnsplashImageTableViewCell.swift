//
//  UnsplashImageTableViewCell.swift
//  U+nsp
//
//  Created by Ali Dinç on 06/08/2021.
//

import UIKit

class UnsplashImageTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var featureImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dimensionsLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    // MARK: - Properties
    var unsplashImage: UnsplashImage? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        featureImageView.contentMode = .scaleAspectFill
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 4
    }
    
    // MARK: - Methods
    func updateView() {
        guard let unsplashImage = unsplashImage else { return }
        
        dimensionsLabel.text = "\(unsplashImage.width) * \(unsplashImage.height)"
        usernameLabel.text = unsplashImage.user.username
        likesLabel.text = String(unsplashImage.likes)
        
        UnsplashController.fetchImage(with: unsplashImage.urls.regularURL) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.featureImageView.image = image
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
        
        UnsplashController.fetchImage(with: unsplashImage.user.profileImage.mediumImageURL) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.profileImageView.image = image
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        featureImageView.image = nil
        profileImageView.image = nil
    }
}
