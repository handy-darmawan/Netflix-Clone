//
//  YoutubeDTO.swift
//  Netflix Clone
//
//  Created by ndyyy on 17/03/24.
//

import Foundation

struct YoutubeResponse: Codable {
    let items: [YoutubeItem]
}

struct YoutubeItem: Codable {
    let id: YoutubeDTO
}

struct YoutubeDTO: Codable {
    let kind: String
    let videoId: String
}
