//
//  MovieCellDelegate.swift
//  Netflix Clone
//
//  Created by ndyyy on 25/03/24.
//

import Foundation

protocol MovieCellDelegate: AnyObject {
    func buttonDidTapped(for type: ButtonType, with movie: Movie)
}
