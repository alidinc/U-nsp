//
//  UnsplashController.swift
//  U+nsp
//
//  Created by Ali Dinç on 06/08/2021.
//

import UIKit

class UnsplashController {
    
    static let cache = NSCache<NSString, UIImage>()
    
    static let baseURL = URL(string: "https://api.unsplash.com")
    static let photoSearchComponent = "search/photos"
    static let clientIDKey = "client_id"
    static let clientIDValue = "t6bj36SI6JgZfShK21D-hTRnfseTefPn_w6bK1gMBXs"
    static let searchTermKey = "query"
    static let itemQuantityKey = "per_page"
    
    static func fetchUnsplashImages(with searchTerm: String, completion: @escaping (Result<[UnsplashImage], NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let photoSearchURL = baseURL.appendingPathComponent(photoSearchComponent)
        
        var components = URLComponents(url: photoSearchURL, resolvingAgainstBaseURL: true)
        let accessQuery = URLQueryItem(name: clientIDKey, value: clientIDValue)
        let searchQuery = URLQueryItem(name: searchTermKey, value: searchTerm)
        let itemNumbersQuery = URLQueryItem(name: itemQuantityKey, value: "100")
        components?.queryItems = [accessQuery, searchQuery, itemNumbersQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        let task = URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.serverError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            do {
                let unsplashImagesTopLevel = try JSONDecoder().decode(UnsplashTopLevel.self, from: data)
                completion(.success(unsplashImagesTopLevel.results))
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.thrownError(error)))
            }
        }
        task.resume()
    }
    
    static func fetchImage(with url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        let cacheKey = NSString(string: url.absoluteString)
        if let image = cache.object(forKey: cacheKey) {
            completion(.success(image))
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.serverError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            guard let image = UIImage(data: data) else { return completion(.failure(.noImage))}
            
            self.cache.setObject(image, forKey: cacheKey) // if it's not in the cache, download a new image
            completion(.success(image))
        }
        task.resume()
    }
}
