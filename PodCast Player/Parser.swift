//
//  Parser.swift
//  PodCast Player
//
//  Created by Jason Wong on 2018-06-20.
//  Copyright © 2018 Jason Wong. All rights reserved.
//

import Foundation

class Parser {

    func getPodcastMetaData(data: Data) -> (title:String?, imageURL:String?) {
        let xml = SWXMLHash.parse(data)
        
        print (xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text as Any)
        return (xml["rss"]["channel"]["title"].element?.text, xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text)
    }
    
    func getEpisodes(data:Data) -> [Episode] {
        
        let xml = SWXMLHash.parse(data)
        
        var episodes : [Episode] = []
        
        for item in xml["rss"]["channel"]["item"].all {
            let episode = Episode()
            if let title = item["title"].element?.text {
                episode.title = title
            }
            if let htmlDescription = item["description"].element?.text {
                episode.htmlDescription = htmlDescription
            }
            if let audioURL = item["link"].element?.text {
                episode.audioURL = audioURL
            }
            if let pubDate = item["pubDate"].element?.text {
                if let date = Episode.formatter.date(from: pubDate) {
                    episode.pubDate = date
                }
            }
            episodes.append(episode)
            // print(episode.pubDate)
        }
        
        return episodes
    }
}
