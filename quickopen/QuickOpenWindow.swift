//
//  QuickOpenWindow.swift
//  quickopen
//
//  Created by 张壹弛 on 3/10/20.
//  Copyright © 2020 oscardoudou. All rights reserved.
//

import Foundation
import Cocoa
class QuickOpenWindow: NSWindow, NSWindowDelegate {
    override init(contentRect: NSRect,
                  styleMask style: NSWindow.StyleMask,
                  backing backingStoreType: NSWindow.BackingStoreType,
                  defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        self.titleVisibility = .hidden
        
//        self.styleMask.remove(.titled) this would make window not movable, which is really annoying
        self.styleMask = .borderless
        self.backgroundColor = .clear
        self.isOpaque = false
        self.isMovableByWindowBackground = true
        //has to assign delegate to window itself, otherwise windowDidResignKey won't be called
        self.delegate = self
    }
    //necessary and require self.delegate = self in init method, instead of write logic in applicationDidResignActive. this NSWindowDelegate method is designated to close window when it is not key window anymore.
    func windowDidResignKey(_ notification: Notification) {
      windowController?.close()
    }

    override var canBecomeKey: Bool {
      return true
    }

}
