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
    //shouldn't be public I think
    public var matchesOutlineView: NSOutlineView!
    public var matches: [Any]!
    private var search: QuickOpenOption!
    
    init(backgroundColor: NSColor, search: QuickOpenOption) {
        print("LeftVC init")
       self.backgroundColor = backgroundColor
        self.search = search
        self.matches = []
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
        print("LeftVC loadView")
        setUpMatchesOutLineView()
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

    override func viewDidLoad() {
        print("LeftVC viewDidLoad before super.viewDidLoad()")
        super.viewDidLoad()
        print("LeftVC viewDidLoad after super.viewDidLoad()")
        
    }
    
}
extension LeftViewController: NSOutlineViewDataSource{
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
    //this method is important to have row focus when setSelected(0) is executed, without this it row won't be focused
    func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
      return OpenQuicklyTableRowView(frame: NSZeroRect)
    }
}

extension LeftViewController: NSOutlineViewDelegate{
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        return search.delegate?.quickOpen(item)
    }
}
