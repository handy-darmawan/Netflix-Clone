//
//  YoutubeNetworkManager.swift
//  Netflix Clone
//
//  Created by ndyyy on 13/03/24.
//

import Foundation

class YoutubeNetworkManager {
    static let shared = YoutubeNetworkManager()

    //get youtube api key from config.plist
    var API_KEY: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist") else { return "Config.plist not found" }
        
        let pathURL = URL(filePath: path)
        guard
            let plist = NSDictionary(contentsOf: pathURL as URL),
            let apiKey = plist.object(forKey: "youtube_api_key") as? String
        else { return "API Key not found" }
        
        return apiKey
    }
    
    let baseURL = "https://www.googleapis.com/youtube/v3/search?"
    let youtubeBaseURL = "https://www.youtube.com/watch?v="
    
    private init() {}
}
