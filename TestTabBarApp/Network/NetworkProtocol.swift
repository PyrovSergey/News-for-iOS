//
//  NetworkProtocol.swift
//  TestTabBarApp
//
//  Created by Sergey on 24/02/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation

protocol NetworkProtocol {
    func successRequest(result: [Article], category: String)
    
    func errorRequest(errorMessage: String)
}
