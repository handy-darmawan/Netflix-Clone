//
//  YoutubeUseCase.swift
//  Netflix Clone
//
//  Created by ndyyy on 15/03/24.
//

import Foundation

class YoutubeUseCase {
    let youtubeRepository: YoutubeRepositoryProtocol
    
    init(youtubeRepository: YoutubeRepositoryProtocol) {
        self.youtubeRepository = youtubeRepository
    }
}
