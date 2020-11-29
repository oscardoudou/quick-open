//
//  QuickOpenWindowController.swift
//  quickopen
//
//  Created by 张壹弛 on 3/10/20.
//  Copyright © 2020 oscardoudou. All rights reserved.
//

import Foundation
import Cocoa

open class QuickOpenWindowController: NSWindowController {
    
    let AUTOSAVE_NAME = "QuickOpenWindow"
    var search: QuickOpenSearch!
    lazy var globalEventMonitor: GlobalEventMonitor = GlobalEventMonitor(mask: [.leftMouseDown, .rightMouseDown]){ [weak self]
        event in
        if let strongSelf = self, strongSelf.windowIsVisible {
            strongSelf.close()
        }
    }
    
    private var windowIsVisible: Bool {
      return window?.isVisible ?? true
    }
    
    override open func windowDidLoad() {
        super.windowDidLoad()
    }
    
    public convenience init(search: QuickOpenSearch){
        let vc = QuickOpenViewController(search: search)
        let window = QuickOpenWindow(contentViewController: vc)
        
        self.init(window: window)
        
        self.search = search
        
        if search.persistPosition {
          window.setFrameAutosaveName(AUTOSAVE_NAME)
        }
    }
    
    override open func close() {
      if windowIsVisible {
//        options.delegate?.windowDidClose()
        super.close()
      }
    }
    
    
    public func toggle(){
        if windowIsVisible {
            close()
            //fix key window status wont return to previous app [https://stackoverflow.com/questions/22081215/]
            NSApplication.shared.hide(self)
            globalEventMonitor.stop()
        }else{
            //not sure what this does
            window?.makeKeyAndOrderFront(self)
            showWindow(self)
            self.window?.level = .floating
            //fix focus not on window after click other app [https://stackoverflow.com/questions/6737396/]
            NSApplication.shared.activate(ignoringOtherApps: true)
            globalEventMonitor.start()
        }
    }
}
