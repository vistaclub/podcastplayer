//
//  Episode.swift
//  PodCast Player
//
//  Created by Jason Wong on 2018-06-20.
//  Copyright © 2018 Jason Wong. All rights reserved.
//

import Cocoa

class Episode {
    var title = ""
    var htmlDescription = ""
    var audioURL = ""
    var pubDate = Date()

    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return formatter
    }()
}
