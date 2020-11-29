//
//  QuickOpenWindow.swift
//  quickopen
//
//  Created by 张壹弛 on 3/10/20.
//  Copyright © 2020 oscardoudou. All rights reserved.
//

import Foundation
import Cocoa
class QuickOpenWindow: NSWindow {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        self.titleVisibility = .hidden
        self.styleMask.remove(.titled)
//        self.styleMask = .borderless
        self.backgroundColor = .clear
        self.isMovableByWindowBackground = true
    }
    //seem unnecessary
    func windowDidResignKey(_ notification: Notification) {
      windowController?.close()
    }
    override var canBecomeKey: Bool {
      return true
    }
}
