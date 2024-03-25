//
//  MovieCellDelegate.swift
//  Netflix Clone
//
//  Created by ndyyy on 25/03/24.
//

import Foundation

protocol DetailViewDelegate: AnyObject {
    func itemTapped(for type: ButtonType, with movie: Movie)
}
