//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Hashem Abounajmi on 13/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import UIKit

public final class ErrorView: UIButton {

    public var message: String? {
        get { return isVisible ? title(for: .normal) : nil }
        set { setMessageAnimated(newValue) }
    }
    
    public var onHide: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureLabel()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
     private func configure() {
         backgroundColor = .errorBackgroundColor
         
         addTarget(self, action: #selector(hideMessageAnimated), for: .touchUpInside)
         configureLabel()
         hideMessage()
     }
    
    private func configureLabel() {
        
        titleLabel?.textColor = .white
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 0
        titleLabel?.font = .systemFont(ofSize: 17)
    }
        
    private var isVisible: Bool {
        return alpha > 0
    }
    
    private func setMessageAnimated(_ message: String?) {
        if let message = message {
            showAnimated(message)
        } else {
            hideMessageAnimated()
        }
    }

    private func showAnimated(_ message: String) {
        setTitle(message, for: .normal)
        contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8  )
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    @objc private func hideMessageAnimated() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed { self.hideMessage() }
        })
    }
    
    private func hideMessage() {
        setTitle(nil, for: .normal)
        contentEdgeInsets = .init(top: -2.5, left: 0, bottom: -2.5, right: 0)
        alpha = 0
        onHide?()
    }
}

extension UIColor {
    static var errorBackgroundColor = UIColor(red: 1.00884, green: 0.500555, blue: 0.481827, alpha: 1)
}
