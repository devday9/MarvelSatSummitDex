//
//  MarvelCharacterController.swift
//  MarvelDex
//
//  Created by Deven Day on 9/26/20.
//

import UIKit

class MarvelCharacterController {
    
    //MARK: - Properties
    static private let baseURl = URL(string: "https://gateway.marvel.com/v1/public")
    static private let characterEndpoint = "characters"
    static private let nameKey = "name"
    static private let apiKeyKey = "apikey"
    static private let apiKeyValue = "653f7be86d9909e5faba77bd047c5469"
    static private let timestampKey = "ts"
    static private let timestamp = "today"
    static private let hashKey = "hash"
    static private let privateKey = "PRIVATEKEY"
    
    //MARK: - Methods
    static func fetchMarvelCharacter(searchTerm: String, completion: @escaping (Result <MarvelCharacter, NetworkError>) -> Void) {
        
        guard let baseURl = baseURl else {return completion(.failure(.invalidURL))}
        let charactersURL = baseURl.appendingPathComponent(characterEndpoint)
        var components = URLComponents(url: charactersURL, resolvingAgainstBaseURL: true)
        
        components?.queryItems = [ URLQueryItem(name: nameKey, value: searchTerm.lowercased()),
                                   URLQueryItem(name: timestampKey, value: timestamp),
                                   URLQueryItem(name: apiKeyKey, value: apiKeyValue),
                                   URLQueryItem(name: hashKey, value: (timestamp+privateKey+apiKeyValue).asMD5())]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        print("CHARACTER URL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                let secondLevelObject = topLevelObject.data
                let marvelCharacters = secondLevelObject.results
                guard let firstMarvelCharacter = marvelCharacters.first else {return completion(.failure(.noData))}
                return completion(.success(firstMarvelCharacter))
            } catch {
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchThumbnail(for character: MarvelCharacter, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        let baseURL = character.thumbnailInfo.path
        let finalURL = baseURL.appendingPathExtension(character.thumbnailInfo.extension)
        print("IMAGE URL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            guard let thumbnail = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            
            completion(.success(thumbnail))
            
        }.resume()
    }
    
    
}//END OF CLASS
