//
//  AlertUtility.swift
//  Netflix Clone
//
//  Created by ndyyy on 26/03/24.
//

import UIKit

class AlertUtility: UIAlertController {
    static func showAlert(with title: String, message: String) {
        guard 
            let window = UIApplication.shared.connectedScenes
                .compactMap ({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })
        else { return }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        window.rootViewController?.present(alert, animated: true)
    }
}
