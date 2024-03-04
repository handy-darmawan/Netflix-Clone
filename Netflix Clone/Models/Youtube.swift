//
//  Youtube.swift
//  Netflix Clone
//
//  Created by ndyyy on 01/03/24.
//

import Foundation

struct YoutubeResponse: Codable {
    let items: [YoutubeVideo]
}

struct YoutubeVideo: Codable {
    let id: IDVideoElement
}

struct IDVideoElement: Codable {
    let kind: String
    let videoId: String
}
