//
//  Extension+UIViewController.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 24.03.2023.
//

import UIKit

extension UIViewController {
    
    func showToast(with message: String) {
        let toastLabel = UILabel()
        let width = view.frame.width / 1.2
        
        toastLabel.frame = CGRect(x: (view.frame.size.width - width) / 2,
                                  y: view.frame.size.height,
                                  width: width,
                                  height: 60)
        toastLabel.backgroundColor = .black
        toastLabel.textColor = .white
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.1,
                       options: .curveEaseIn,
                       animations: {
            toastLabel.frame = CGRect(x: (self.view.frame.size.width - width) / 2,
                                      y: self.view.frame.size.height - 100,
                                      width: width,
                                      height: 60)
        }, completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    UIView.animate(withDuration: 0.3,
                                   delay: 0.1,
                                   options: .curveEaseIn,
                                   animations: {
                        toastLabel.frame = CGRect(x: (self.view.frame.size.width - width) / 2,
                                                  y: self.view.frame.size.height,
                                                  width: width,
                                                  height: 60)
                    }, completion: { finished in
                        if finished {
                            toastLabel.removeFromSuperview()
                        }
                    })
                }
            }
        })
    }
}
