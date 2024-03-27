//
//  MovieNetworkManager.swift
//  Netflix Clone
//
//  Created by ndyyy on 13/03/24.
//

import Foundation


class MovieNetworkManager {
    static let shared = MovieNetworkManager()
    
    var API_KEY: String {
        //get youtube api key from config.plist
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist") else { return "Config.plist not found" }

        let pathURL = URL(filePath: path)
        guard
            let plist = NSDictionary(contentsOf: pathURL as URL),
            let apiKey = plist.object(forKey: "tmbd_api_key") as? String
        else { return "API Key not found" }
        
        return apiKey
    }
    
    let baseURL = "https://api.themoviedb.org/3"
    let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    
    private init() {}
}
