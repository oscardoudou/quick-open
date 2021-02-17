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
    
    private var splitVC: SplitViewController!
    
    private var quickOpenWindowController: QuickOpenWindowController? {
      return view.window?.windowController as? QuickOpenWindowController
    }
    
    init(search : QuickOpenOption) {
      super.init(nibName: nil, bundle: nil)
      self.search = search
      self.matches = []
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
//        setUpScrollView()
        setUpStackView()
        setUpVisualEffectView()
        
        stackView.addArrangedSubview(searchField)
//        stackView.addArrangedSubview(scrollView)
        splitVC = SplitViewController(leftScrollDocumentView: matchesOutlineView)
        print(splitVC.view)
        print(splitVC.splitView)
        stackView.addArrangedSubview(splitVC.splitView)
//        splitVC.view.translatesAutoresizingMaskIntoConstraints = true
//        splitVC.view.autoresizingMask = [.height, .width]
//        splitVC.splitView.setPosition(150, ofDividerAt:0)
//        splitVC.splitView.adjustSubviews()
        visualEffectView.addSubview(stackView)
        
//        splitVC.splitView.setFrameSize(NSSize(width: 400, height: 250))
        view.addSubview(visualEffectView)
//        print(splitVC.view.contentHuggingPriority(for: .horizontal))
//        print(stackView.arrangedSubviews[1].contentHuggingPriority(for: .horizontal))
//        print(splitVC.view.contentHuggingPriority(for: .vertical))
//        print(stackView.arrangedSubviews[1].contentHuggingPriority(for: .vertical))
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
    }
    private func reLoadMatches(){
        matchesOutlineView.reloadData()
        updateView()
    }
    private func updateView(){
        let rowHeight = matches.count > 0 ? CGFloat(250) : 0
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
        //have remedy of splitView in searchbox after clear text, not sure if it is bc initially splitView has height even nothing in the textField(no matches)
        stackView.spacing = matches.count > 0 ? 5.0 : 0
//        splitVC.splitView.setFrameSize(NSSize(width: 400, height: 250))'
        setupSplitViewConstraints()
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
        //required
        matchesOutlineView.delegate = self
        //required
        matchesOutlineView.dataSource = self
        //avoid header row
        matchesOutlineView.headerView = nil
        matchesOutlineView.wantsLayer = true
        //use sourceList so there is no background
        matchesOutlineView.selectionHighlightStyle = .sourceList
        //honestly dont understand why adding column to the view is important. I mean without column, view is still createe, right, why delegate can't be called without this stmt
        let column = NSTableColumn()
        matchesOutlineView.addTableColumn(column)
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
    private func setupSplitViewConstraints() {
//                splitVC.splitViewItems[0].viewController.view.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
//                splitVC.splitViewItems[1].viewController.view.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
        let splitViewConstratints = [
            splitVC.splitViewItems[0].viewController.view.widthAnchor.constraint(equalToConstant: 200),
            splitVC.splitViewItems[1].viewController.view.widthAnchor.constraint(equalToConstant: 300)
        ]
        NSLayoutConstraint.activate(splitViewConstratints)
    }


}
extension QuickOpenViewController: NSOutlineViewDataSource{
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return matches.count
    }
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return matches[index]
    }
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return search.height
    }
}

extension QuickOpenViewController: NSOutlineViewDelegate{
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        return search.delegate?.quickOpen(item)
    }
}
