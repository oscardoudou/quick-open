//
//  QuickOpenSearch.swift
//  quickopen
//
//  Created by 张壹弛 on 3/17/20.
//  Copyright © 2020 oscardoudou. All rights reserved.
//

import Foundation
import Cocoa
public class QuickOpenSearch{
    public init(){
        self.radius = 7
        self.height = 44
        self.width = 400
        self.font = NSFont.systemFont(ofSize: 20, weight: .light)
        self.placeholder = "Quick Open"
        self.persistPosition = true
    }
    public var height: CGFloat
    public var width: CGFloat
    public var radius: CGFloat
    public var font: NSFont
    public var placeholder: String
    //why do we need delegate here anyway, we do pass QuickOpenSearch to windowcontroller, but we don't do anything further with delegate field. I think it is just a interface to program with
//    public var delegate: QuickOpenSearchDelegate?
    public var persistPosition: Bool
}
