//
//  ErrorType.swift
//  Netflix Clone
//
//  Created by ndyyy on 18/03/24.
//

import Foundation

enum NetworkError: Error {
    case failedToGetData
    case failedToCreateURL
    case failedToAddPercentDecoding
    var localizedDescription: String {
        switch self {
        case .failedToGetData: return "Failed to get data from API"
        case .failedToCreateURL: return "Failed to create URL"
        case .failedToAddPercentDecoding: return "Failed to add percent decoding"
        }
    }
}

enum LocalError: Error {
    case failedToGetData
    case failedToSaveData
    case failedToQueryData
    case failedToDeleteData
    var localizedDescription: String {
        switch self {
        case .failedToGetData: return "Failed to get data from local storage"
        case .failedToSaveData: return "Failed to save data to local storage"
        case .failedToQueryData: return "Failed to query data from local storage"
        case .failedToDeleteData: return "Failed to delete data from local storage"
        }
    }
}
