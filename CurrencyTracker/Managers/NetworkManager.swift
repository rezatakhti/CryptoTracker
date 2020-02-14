//
//  NetworkManager.swift
//  CurrencyTracker
//
//  Created by Reza Takhti on 1/7/20.
//  Copyright © 2020 Reza Takhti. All rights reserved.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://api.coingecko.com/api/v3"
    
    private init(){}
    
    func getPrice(for cryptoID: String, completed: @escaping(Result<CurrencyModelNetwork, ErrorMessage>) -> Void) {
        let endpoint = baseURL + "/coins/\(cryptoID)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidCryptoID))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let priceData = try decoder.decode(CurrencyModelNetwork.self, from: data)
                completed(.success(priceData))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func getHistoricalData(for cryptoID: String, lengthInDays length: Int, completed: @escaping(Result<HistoricalData, ErrorMessage>) -> ()){
        let endpoint = baseURL + "/coins/\(cryptoID)/market_chart?vs_currency=usd&days=\(length)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidCryptoID))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let historicalData = try decoder.decode(HistoricalData.self, from: data)
                completed(.success(historicalData))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
        
    }
    
}

