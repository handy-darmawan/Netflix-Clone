//
//  ViewInteraction.swift
//  Netflix Clone
//
//  Created by ndyyy on 27/03/24.
//

import UIKit

protocol ViewInteraction {
    associatedtype ViewType: UIView
    var viewInteraction: ViewType { get }
    
    func enableViewInteraction()
    func disableViewInteraction()
}

extension ViewInteraction {
    func enableViewInteraction() {
        viewInteraction.isUserInteractionEnabled = true
    }
    
    func disableViewInteraction() {
        viewInteraction.isUserInteractionEnabled = false
    }
}
