//
//  MarvelCharacterViewController.swift
//  MarvelDex
//
//  Created by Deven Day on 9/26/20.
//

import UIKit

class MarvelCharacterViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var characterSearchBar: UISearchBar!
    @IBOutlet weak var characterThumbnailImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        characterSearchBar.delegate = self
    }
 
    //MARK: - Methods
    func fetchImageAndUpdateUI(for marvelCharacter: MarvelCharacter) {
        
        MarvelCharacterController.fetchThumbnail(for: marvelCharacter) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                
                case .success(let image):
                    self.characterThumbnailImageView.image = image
                    self.characterNameLabel.text = marvelCharacter.name
                    self.characterDescriptionLabel.text = marvelCharacter.description
                    
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
}//END OF CLASS

//MARK: - Extension
extension MarvelCharacterViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else {return}
        
        MarvelCharacterController.fetchMarvelCharacter(searchTerm: searchTerm) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                
                case .success(let character):
                    self.fetchImageAndUpdateUI(for: character)
                    
                case .failure(let error):
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
}//END OF EXTENSION
