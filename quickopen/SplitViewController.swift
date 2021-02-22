//
//  SplitViewController.swift
//  quickopen
//
//  Created by 张壹弛 on 12/28/20.
//  Copyright © 2020 oscardoudou. All rights reserved.
//

import Foundation
import Cocoa

class SplitViewController: NSSplitViewController{
//    private var matchesOutlineView : NSView!
    public var leftVC: LeftViewController!
    public var rightVC: RightViewController!
    private var search: QuickOpenOption!
    private func patch() {
        let v = NSSplitView()
        v.isVertical = true
        v.dividerStyle = .thin
        splitView = v
        leftVC = LeftViewController(backgroundColor: .red, search: search)
        rightVC = RightViewController(backgroundColor: .green)
        splitViewItems = [
            NSSplitViewItem(viewController: leftVC),
            NSSplitViewItem(viewController: rightVC),
        ]
//        splitViewItems[0].minimumThickness = 150
//        splitViewItems[1].minimumThickness = 250

//        let frame = NSRect(x: 0,y: 0,width: CGFloat(400), height: CGFloat(250))
//        v.frame = frame
        
//        let newSize = NSSize(width: 400, height: 250)
//        v.setFrameSize(newSize)
    
    }
    convenience init(search: QuickOpenOption) {
        print("SplitView init")
        self.init(nibName: nil, bundle: nil)
        self.search = search
        patch()
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        patch()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        patch()
    }
    
    override func viewWillAppear() {
        splitView.setPosition(150, ofDividerAt: 0)
    }

    override func loadView() {
        print("SplitVC loadView()")
        view = splitView
    }

    override func viewDidLoad() {
        print("SplitVC viewDidLoad before super.viewDidLoad()")
        super.viewDidLoad()
        print("SplitVC viewDidLoad after super.viewDidLoad()")
    }

}
