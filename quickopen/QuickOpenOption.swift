//
//  QuickOpenSearch.swift
//  quickopen
//
//  Created by 张壹弛 on 3/17/20.
//  Copyright © 2020 oscardoudou. All rights reserved.
//

import Foundation
import Cocoa
public class QuickOpenOption{
    public init(){
        self.radius = 7
        self.height = 50
        self.width = 650
        //textField contentSize is fontsize + 4, so if font is 26, then contentSize is 30, along with top bottom edgeInset constraint that's 50, which compress the room of splitView
        self.font = NSFont.systemFont(ofSize: 26, weight: .light)
        self.material = .popover
        //stackView also use this.
        self.edgeInsets = NSEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        self.placeholder = "Quick Open"
        self.persistPosition = true
        self.persistMatches = false
    }
    public var height: CGFloat
    public var width: CGFloat
    public var radius: CGFloat
    public var font: NSFont
    public var edgeInsets: NSEdgeInsets
    public var placeholder: String
    //why do we need delegate here anyway, we do pass QuickOpenSearch to windowcontroller, but we don't do anything further with delegate field. I think it is just a interface to program with
//    public var delegate: QuickOpenSearchDelegate?
    public var persistPosition: Bool
    public var material: NSVisualEffectView.Material
    public var delegate: QuickOpenDelegate?
    public var persistMatches: Bool
}
