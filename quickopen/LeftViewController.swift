//
//  LeftViewController.swift
//  quickopen
//
//  Created by 张壹弛 on 12/28/20.
//  Copyright © 2020 oscardoudou. All rights reserved.
//

import Foundation
import Cocoa

class LeftViewController: NSViewController{
    private let backgroundColor: NSColor
    private let matchesOutlineView: NSView
    
    init(backgroundColor: NSColor, scrollDocumentView: NSView) {
       self.backgroundColor = backgroundColor
       self.matchesOutlineView = scrollDocumentView
       super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
//       view = NSView()
//       view.wantsLayer = true
//       view.layer?.backgroundColor = backgroundColor.cgColor
        
//        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
//        view.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
        
        view = NSScrollView()
        view.layer?.backgroundColor = backgroundColor.cgColor
        if let scrollView = view as? NSScrollView {
            scrollView.documentView = matchesOutlineView
            scrollView.drawsBackground = false
            scrollView.wantsLayer = true
            scrollView.borderType = NSBorderType.noBorder
            scrollView.autohidesScrollers = true
            scrollView.hasVerticalScroller = true
            scrollView.translatesAutoresizingMaskIntoConstraints = true
        }
        
        
    }
    
}
