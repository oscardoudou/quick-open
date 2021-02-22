//
//  QuickOpenViewController.swift
//  quickopen
//
//  Created by 张壹弛 on 3/10/20.
//  Copyright © 2020 oscardoudou. All rights reserved.
//

import Foundation
import Cocoa

enum KeyCode {
  static let esc: UInt16 = 53
}

class QuickOpenViewController: NSViewController, NSTextFieldDelegate {

    private var search: QuickOpenOption!
    private var matches: [Any]!
    //this fix the remainding portion of splitView when search text is empty(matches.count == 0)
    {
        didSet{
            let splitView = stackView.arrangedSubviews[1]
            splitView.isHidden = matches.count == 0 ? true : false
            leftVC.matches = matches
        }
    }
    private var visualEffectView: NSVisualEffectView!
    private var stackView: NSStackView!
    private var matchesOutlineView: NSOutlineView!
    private var searchField: NSTextField!

    private var splitVC: SplitViewController!
    private var leftVC: LeftViewController!
    private var rightVC: RightViewController!
    
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
        print("quickopenVC loadView()")
        let frame = NSRect(x: 0,y: 0,width: search.width, height: search.height)

      view = NSView()
      view.frame = frame
      view.wantsLayer = true
        view.layer?.cornerRadius = search.radius + 1
    
        setUpSearchField()
        setUpStackView()
        setUpVisualEffectView()
        
        stackView.addArrangedSubview(searchField)
        splitVC = SplitViewController(search: search)
        //this line is important! otherwise splitView wont show up. Must did something wrong
//        print("splitVC.view: \(splitVC.view)")
        stackView.addArrangedSubview(splitVC.view)
        //this line doesn't work, try set autosaveName also not working. Ugh, for now just set each splitView width anchor constraints
//        splitVC.splitView.setPosition(50, ofDividerAt:0)
        visualEffectView.addSubview(stackView)
        view.addSubview(visualEffectView)
    }

    override func viewDidLoad() {
        leftVC = splitVC.leftVC
        rightVC = splitVC.rightVC
        matchesOutlineView = leftVC.matchesOutlineView
        print("quickopenVC viewDidLoad before super.viewDidLoad()")
        super.viewDidLoad()
        print("quickopenVC viewDidLoad before super.viewDidLoad()")
        setupConstraints()
        setupSplitViewConstraints(leftViewWidth: 250)
        NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: keyDown)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear() {
        if !search.persistMatches {
            searchField.stringValue = ""
            clearMatches()
        }
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
    func keyDown(with event: NSEvent) -> NSEvent?{
        let keyCode = event.keyCode
        if keyCode == KeyCode.esc {
            quickOpenWindowController?.toggle()
            return nil
        }
        return event
    }
    private func clearMatches(){
        matches = []
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
    private func setupSplitViewConstraints(leftViewWidth: CGFloat) {
        let splitViewConstratints = [
            leftVC.view.widthAnchor.constraint(equalToConstant: leftViewWidth),
            rightVC.view.widthAnchor.constraint(equalToConstant: search.width - leftViewWidth),
        ]
        NSLayoutConstraint.activate(splitViewConstratints)
    }


}
