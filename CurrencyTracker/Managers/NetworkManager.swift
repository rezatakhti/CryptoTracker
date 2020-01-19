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
    
    func getPrice(for cryptoID: String, completed: @escaping(CurrencyModelNetwork?, String?) -> Void) {
        let endpoint = baseURL + "/coins/\(cryptoID)"
        
        guard let url = URL(string: endpoint) else {
            completed(nil, "This cryptoID created an invalid request. Please try again.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(nil, "Unable to complete your request. Pleaes check your internet connection")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, "Invalid response from the server. Please try again.")
                return
            }
            
            guard let data = data else {
                completed(nil, "The data received from the server was invalid. Please try again.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let priceData = try decoder.decode(CurrencyModelNetwork.self, from: data)
                completed(priceData, nil)
            } catch {
                completed(nil, "The data received from the server was invalid. Please try again.")
            }
        }
        
        task.resume()
    }
    
}
