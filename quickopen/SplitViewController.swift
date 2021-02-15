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
    private var matchesOutlineView : NSView!
    private func patch() {
        let v = NSSplitView()
        v.isVertical = true
        v.dividerStyle = .thin
        splitView = v
        let lvc = LeftViewController(backgroundColor: .red, scrollDocumentView: matchesOutlineView )
        let rvc = RightViewController(backgroundColor: .green)
        splitViewItems = [
            NSSplitViewItem(viewController: lvc),
            NSSplitViewItem(viewController: rvc),
        ]
//        splitViewItems[0].minimumThickness = 150
//        splitViewItems[1].minimumThickness = 250

//        let frame = NSRect(x: 0,y: 0,width: CGFloat(400), height: CGFloat(250))
//        v.frame = frame
        
//        let newSize = NSSize(width: 400, height: 250)
//        v.setFrameSize(newSize)
    
    }
    convenience init(leftScrollDocumentView: NSView) {
        self.init(nibName: nil, bundle: nil)
        matchesOutlineView = leftScrollDocumentView
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
}
