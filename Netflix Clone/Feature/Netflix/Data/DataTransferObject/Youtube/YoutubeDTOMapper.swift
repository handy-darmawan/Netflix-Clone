//
//  YoutubeDTOMapper.swift
//  Netflix Clone
//
//  Created by ndyyy on 17/03/24.
//

import Foundation

struct YoutubeDTOMapper {
    static func map(_ dto: YoutubeDTO) -> Youtube {
        return Youtube(
            kind: dto.kind,
            videoId: dto.videoId
        )
    }
}
