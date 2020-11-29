//
//  QuickOpenViewController.swift
//  quickopen
//
//  Created by 张壹弛 on 3/10/20.
//  Copyright © 2020 oscardoudou. All rights reserved.
//

import Foundation
import Cocoa

class QuickOpenViewController: NSViewController, NSTextFieldDelegate {
    
    private var search: QuickOpenSearch!
    
    private var visualEffectView: NSVisualEffectView!
    private var stackView: NSStackView!
    private var searchField: NSTextField!
    
    var quickOpenWindowController: QuickOpenWindowController? {
      return view.window?.windowController as? QuickOpenWindowController
    }
    
    init(search : QuickOpenSearch) {
      super.init(nibName: nil, bundle: nil)
        self.search = search
    }

    required init?(coder: NSCoder) {
      super.init(coder: coder)
    }

    override func loadView() {
      let frame = NSRect(x: 0,y: 0,width: 400,height: 44)

      view = NSView()
      view.frame = frame
      view.wantsLayer = true
        view.layer?.cornerRadius = search.radius + 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchField()
        setUpVisualEffectView()
        setUpStackView()
        stackView.addArrangedSubview(searchField)
        visualEffectView.addSubview(stackView)
        
        view.addSubview(visualEffectView)
        
        setupConstraints()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear() {
        view.window?.makeFirstResponder(searchField)
    }
    override var acceptsFirstResponder: Bool {
      return true
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    private func setUpVisualEffectView(){
        let frame = NSRect(x: 0 ,y: 0, width: 400, height: 44)
        visualEffectView = NSVisualEffectView()
        visualEffectView.state = .active
        visualEffectView.frame = frame
        visualEffectView.wantsLayer = true
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.layer?.cornerRadius = 7
        visualEffectView.material = .popover
    }
    private func setUpStackView(){
        stackView = NSStackView()
        stackView.spacing = 0.0
        stackView.orientation = .vertical
        stackView.distribution = .fillEqually
        stackView.edgeInsets = NSEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func setUpSearchField(){
        //as long as set frame to search field, search box is not moveable 
//        let frame = NSRect(x: 0 ,y: 0, width: 400, height: 44)
        searchField = NSTextField()
//        searchField.frame = frame
        searchField.delegate = self
        searchField.alignment = .left
        searchField.isEditable = true
        searchField.isBezeled = false
        searchField.isSelectable = true
        searchField.font =  NSFont.systemFont(ofSize: 20, weight: .light)
        searchField.focusRingType = .none
        searchField.drawsBackground = false
        searchField.placeholderString = "hey"
    }
    private func setupConstraints() {
      let stackViewConstraints = [
        stackView.topAnchor.constraint(equalTo: visualEffectView.topAnchor),
        stackView.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor),
        stackView.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor),
        stackView.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor)
      ]

      NSLayoutConstraint.activate(stackViewConstraints)
    }


}


