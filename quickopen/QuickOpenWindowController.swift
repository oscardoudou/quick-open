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
    var search: QuickOpenOption!
//    lazy var globalEventMonitor: GlobalEventMonitor = GlobalEventMonitor(mask: [.leftMouseDown, .rightMouseDown]){ [weak self]
//        event in
//        if let strongSelf = self, strongSelf.windowIsVisible {
//            strongSelf.close()
//        }
//    }
    
    private var windowIsVisible: Bool {
      return window?.isVisible ?? false
    }
    
//    override open func windowDidLoad() {
//        super.windowDidLoad()
//    }
    
    public convenience init(search: QuickOpenOption){
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
        print("window?.isKeyWindow:\(window?.isKeyWindow)")
        super.close()
      }
    }
    
    
    public func toggle(){
        if windowIsVisible {
            close()
            //fix key window status wont return to previous app [https://stackoverflow.com/questions/22081215/]
            NSApplication.shared.hide(self)
//            globalEventMonitor.stop()
        }else{
            //not sure what this does
//            window?.makeKeyAndOrderFront(self)
            showWindow(self)
            //when running as agent, except from no app icon in dock this trivial benifit.
            //simply show hide is not enough when running as agent, require floating, which is also a side effect caused by not running as app
            //whne running as app, you don't need floating if you are using the app currently. but you don't have global key monitor benifit from this anyway. and if you hate the idea of actuall app prefer daemon like, then you probably need to make it floating
//            self.window?.level = .floating
            //fix focus not on window after click other app [https://stackoverflow.com/questions/6737396/]
            //no need floating and NSApplication.shared.hide(self) when trying to close
            NSApplication.shared.activate(ignoringOtherApps: true)
//            globalEventMonitor.start()
        }
    }
}
