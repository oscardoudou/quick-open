//
//  GlobalEventMonitor.swift
//  TotalRecall
//
//  Created by 张壹弛 on 11/29/20.
//  Copyright © 2020 oscardoudou. All rights reserved.
//

import Foundation
import Cocoa

public class GlobalEventMonitor{
    private let mask: NSEvent.EventTypeMask
    private let handler : (NSEvent?)->()
    private var monitor: Any?
    
    public init(mask: NSEvent.EventTypeMask, handler: @escaping(NSEvent?)->()){
        self.mask = mask
        self.handler = handler
    }
    deinit {
        stop()
    }
    public func start(){
        monitor  = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }
    public func stop(){
        if monitor != nil{
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}

