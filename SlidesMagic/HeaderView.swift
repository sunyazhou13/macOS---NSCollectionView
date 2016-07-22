//
//  HeaderView.swift
//  SlidesMagic
//
//  Created by sunyazhou on 16/7/22.
//  Copyright © 2016年 razeware. All rights reserved.
//

import Cocoa

class HeaderView: NSView {

    @IBOutlet weak var sectionTitle: NSTextField!
  
    @IBOutlet weak var imageCount: NSTextField!
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
      
        NSColor(calibratedWhite: 0.8, alpha: 0.8).set()
        NSRectFillUsingOperation(dirtyRect, NSCompositingOperation.CompositeSourceOver)
    }
    
}
