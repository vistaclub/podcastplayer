//
//  Parser.swift
//  PodCast Player
//
//  Created by Jason Wong on 2018-06-20.
//  Copyright © 2018 Jason Wong. All rights reserved.
//

import Foundation

class Parser {

    // func getPodcastMetaData(data: Data) -> String? {
    func getPodcastMetaData(data: Data) -> (title:String?, imageURL:String?) {
         // print("WOOHOO")
        
        let xml = SWXMLHash.parse(data)
        
        print (xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text as Any)
        // return xml["rss"]["channel"]["title"].element?.text
        return (xml["rss"]["channel"]["title"].element?.text, xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text)
    }
}
