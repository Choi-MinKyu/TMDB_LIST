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
    
    func tv(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/tv/day?api_key=\(Constants.apiKey)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failed))
            }
        }
        
        task.resume()
    }
    
    func popular(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/popular?api_key=\(Constants.apiKey)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failed))
            }
        }
        
        task.resume()
    }
    
    func commingSoon(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/upcoming?api_key=\(Constants.apiKey)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failed))
            }
        }
        
        task.resume()
    }
    
    func topRates(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/top_rated?api_key=\(Constants.apiKey)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failed))
            }
        }
        
        task.resume()
    }
}

extension SimpleAPI {
    func searchDefault(completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/discover/movie?api_key=\(Constants.apiKey)&language=ko-KR&sort_by=popularity.desc&include_adult=true&include_video=true&page=1&with_watch_monetization_types=flatrate") else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failed))
            }
        }
        
        task.resume()
    }

    func search(with query: String, completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.baseUrl)/3/search/movie?api_key=\(Constants.apiKey)&query=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(APIError.failed))
            }

        }
        task.resume()
    }
}
