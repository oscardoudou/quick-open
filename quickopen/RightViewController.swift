
//
//  RightViewController.swift
//  quickopen
//
//  Created by 张壹弛 on 12/28/20.
//  Copyright © 2020 oscardoudou. All rights reserved.
//

import Foundation
import Cocoa

class RightViewController: NSViewController{
    private let backgroundColor: NSColor

    init(backgroundColor: NSColor) {
       self.backgroundColor = backgroundColor
       super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
       view = NSView()
       view.wantsLayer = true
       view.layer?.backgroundColor = backgroundColor.cgColor
//        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 160).isActive = true
//        view.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true

    }
}
