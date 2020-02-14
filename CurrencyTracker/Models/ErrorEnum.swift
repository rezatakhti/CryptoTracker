//
//  ErrorEnum.swift
//  CurrencyTracker
//
//  Created by Reza Takhti on 2/13/20.
//  Copyright © 2020 Reza Takhti. All rights reserved.
//

import UIKit

enum ErrorMessage: String, Error{
    case invalidCryptoID = "This cryptoID created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Pleaes check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
}

