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

    private var search: QuickOpenOption!
    private var matches: [Any]!
    
    private var visualEffectView: NSVisualEffectView!
    private var stackView: NSStackView!
    private var scrollView: NSScrollView!
    private var matchesOutlineView: NSOutlineView!
    private var searchField: NSTextField!
    
    private var quickOpenWindowController: QuickOpenWindowController? {
      return view.window?.windowController as? QuickOpenWindowController
    }
    
    init(search : QuickOpenOption) {
      super.init(nibName: nil, bundle: nil)
        self.search = search
    }

    required init?(coder: NSCoder) {
      super.init(coder: coder)
    }

    override func loadView() {
        let frame = NSRect(x: 0,y: 0,width: search.width, height: search.height)

      view = NSView()
      view.frame = frame
      view.wantsLayer = true
        view.layer?.cornerRadius = search.radius + 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchField()
        setUpMatchesOutLineView()
        setUpScrollView()
        setUpStackView()
        setUpVisualEffectView()
        
        stackView.addArrangedSubview(searchField)
        stackView.addArrangedSubview(scrollView)
        visualEffectView.addSubview(stackView)
        
        view.addSubview(visualEffectView)
        
        setupConstraints()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear() {
        searchField.stringValue = ""
        view.window?.makeFirstResponder(searchField)
    }
    override var acceptsFirstResponder: Bool {
      return true
    }
    
    override func keyUp(with event: NSEvent) {

      let text = searchField.stringValue
      matches = search.delegate?.textWasEntered(toBeSearched: text)
      reLoadMatches()
      print("text to be searched: \(text)")
    }
    private func reLoadMatches(){
        matchesOutlineView.reloadData()
        updateView()
    }
    private func updateView(){
        let rowHeight = CGFloat(250)
        let newHeight = search.height + rowHeight
        let newSize = NSSize(width: search.width, height: newHeight)

        guard var frame = view.window?.frame else {return}
        
        print("frame.origin.y:  \(frame.origin.y)");
        frame.origin.y += frame.size.height
        frame.origin.y -= newSize.height
        frame.size = newSize
        
        view.setFrameSize(newSize)
        visualEffectView.setFrameSize(newSize)
        view.window?.setFrame(frame, display: true)
        stackView.spacing = 4.0
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
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
        searchField.font =  search.font
        searchField.focusRingType = .none
        searchField.drawsBackground = false
        searchField.placeholderString = search.placeholder
    }
    private func setUpMatchesOutLineView(){
        matchesOutlineView = NSOutlineView()
        //avoid header row
        matchesOutlineView.headerView = nil
        matchesOutlineView.wantsLayer = true
        //use sourceList so there is no background
        matchesOutlineView.selectionHighlightStyle = .sourceList
    }
    private func setUpScrollView(){
        scrollView = NSScrollView()
        scrollView.drawsBackground = false
//        scrollView.wantsLayer = true
        scrollView.documentView = matchesOutlineView
        scrollView.borderType = .noBorder
        scrollView.autohidesScrollers = true
        scrollView.hasVerticalScroller = true
        scrollView.translatesAutoresizingMaskIntoConstraints = true

    }
    private func setUpStackView(){
        stackView = NSStackView()
        stackView.spacing = 0.0
        stackView.orientation = .vertical
        stackView.distribution = .fillEqually
        stackView.edgeInsets = search.edgeInsets
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func setUpVisualEffectView(){
        let frame = NSRect(x: 0 ,y: 0, width: search.width, height: search.height)
        visualEffectView = NSVisualEffectView()
        visualEffectView.frame = frame
        visualEffectView.state = .active
        visualEffectView.wantsLayer = true
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.layer?.cornerRadius = search.radius
        visualEffectView.material = search.material
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


