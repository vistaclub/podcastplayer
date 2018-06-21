//
//  TheSplitController.swift
//  PodCast Player
//
//  Created by Jason Wong on 2018-06-20.
//  Copyright © 2018 Jason Wong. All rights reserved.
//

import Cocoa

class TheSplitController: NSSplitViewController {

    @IBOutlet weak var podcastsItem: NSSplitViewItem!    
    @IBOutlet weak var episodesItem: NSSplitViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        if let podcastsVC = podcastsItem.viewController as? PodcastViewController {
            if let episodesVC = episodesItem.viewController as? EpisodesViewController {
                podcastsVC.episodesVC = episodesVC
                episodesVC.podcastVC = podcastsVC
            }
        }
    }
}
