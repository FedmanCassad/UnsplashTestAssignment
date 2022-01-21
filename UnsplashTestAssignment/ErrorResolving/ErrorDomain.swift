//
//  ErrorDomain.swift
//  UnsplashTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import Foundation

enum ErrorDomain: Error {
    case failedToReceiveData
    case jsonParseError

    var description: (title: String, message: String) {
        switch self {
        case .failedToReceiveData:
            return ("Data error", "Failed to receive data, check your connection")
        case .jsonParseError:
            return ("Parsing error" , "Error parsing received data, ask your dumb developer to fix this issue")
        }
    }
}
