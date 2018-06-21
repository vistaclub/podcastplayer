//
//  EpisodeCell.swift
//  PodCast Player
//
//  Created by Jason Wong on 2018-06-21.
//  Copyright © 2018 Jason Wong. All rights reserved.
//

import Cocoa
import WebKit

class EpisodeCell: NSTableCellView {

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var pubDateLabel: NSTextField!
    @IBOutlet weak var descriptionWebView: WKWebView!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
