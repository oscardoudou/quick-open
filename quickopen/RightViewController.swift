
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
    private var imageView: NSImageView!
    private var scrollView: NSScrollView!
    init(backgroundColor: NSColor) {
        print("RightVC init")
       self.backgroundColor = backgroundColor
       super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
       print("RightVC loadView")
       scrollView = NSScrollView()
       view = NSView()
       view.addSubview(scrollView)
//       scrollView.wantsLayer = true
//       scrollView.layer?.backgroundColor = backgroundColor.cgColor
//        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 160).isActive = true
//        view.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true

    }
    override func viewDidLoad() {
        print("RightVC viewDidLoad before super.viewDidLoad()")
        super.viewDidLoad()
        print("RightVC viewDidLoad after super.viewDidLoad()")
        imageView = NSImageView()

            scrollView.drawsBackground = false
            scrollView.wantsLayer = true
            scrollView.borderType = NSBorderType.noBorder
            scrollView.autohidesScrollers = true
            scrollView.hasVerticalScroller = true
//            scrollView.translatesAutoresizingMaskIntoConstraints = true

            scrollView.allowsMagnification = true
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            scrollView.translatesAutoresizingMaskIntoConstraints = false

    }

    func showImageDetail(image: NSImage?){
        var imageRect: NSRect
        imageView.image = image
        //if user remove the file it will crash here
        imageRect = NSMakeRect(0.0, 0.0, view.frame.width, view.frame.height)
        imageView.setFrameSize(CGSize(width: imageRect.width, height: imageRect.height))
        imageView.imageScaling = .scaleProportionallyUpOrDown
            scrollView.documentView = imageView
    }
}
