//
//  SympleAPI.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/13.
//

import Foundation

final class SimpleAPI {
    static let shared = SimpleAPI()
    
    enum Constants {
        // id : SAT_RX
        // PW : qwer????
        static let apiKey = "7c74f5559350c8f3ee33a106b0b6bf84"
        static let baseUrl = "https://api.themoviedb.org"
    }
    
    enum APIError: Error {
        case failed
    }

    func movies(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/movie/day?api_key=\(Constants.apiKey)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failed))
            }
        }
        
        task.resume()
    }
}
