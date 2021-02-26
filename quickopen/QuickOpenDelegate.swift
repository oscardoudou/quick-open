//
//  QuickOpenDelegate.swift
//  quickopen
//
//  Created by 张壹弛 on 12/12/20.
//  Copyright © 2020 oscardoudou. All rights reserved.
//

import Foundation
import Cocoa

public protocol QuickOpenDelegate {
    func recordWasSelected(selected record: Any) -> NSImage?
    func textWasEntered(toBeSearched text: String) -> [Any]
    /// return row for outlineview
    func quickOpen(_ record: Any) -> NSView?
}
