//
//  ViewController.swift
//  PodCast Player
//
//  Created by Jason Wong on 2018-06-20.
//  Copyright © 2018 Jason Wong. All rights reserved.
//

import Cocoa

class PodcastViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var podcastURLTextField: NSTextField!
    
    var podcasts : [Podcast] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        podcastURLTextField.stringValue = "http://www.espn.com/espnradio/podcast/feeds/itunes/podCast?id=2406595"
    }
    
    @IBAction func addButtonClicked(_ sender: AnyObject) {
        if let url = URL(string: podcastURLTextField.stringValue) {
            
            URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
                
                if error != nil {
                    print(error as Any)
                    
                } else {
                    
                    if data != nil {
                        let parser = Parser()
                        let info = parser.getPodcastMetaData(data: data!)
                        
                        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                            let podcast = Podcast(context: context)
                            
                            podcast.rssURL = self.podcastURLTextField.stringValue
                            podcast.imageURL = info.imageURL
                            podcast.title = info.title
                            
                            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                            
                            self.getPodcasts()
                        }
                    }
                }
                }.resume()
            
            podcastURLTextField.stringValue = ""
        }
        
        func numberOfRows(in tableView: NSTableView ) -> Int {
            return podcasts.count
        }
        
        func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "podcastcell"), owner: self) as? NSTableCellView

            let podcast = podcasts[row]
            
            if podcast.title != nil {
                cell?.textField?.stringValue = podcast.title!
            } else {
                cell?.textField?.stringValue = "UNKOWN TITLE"
            }
            return cell
        }
    }
    
    

    func getPodcasts() {
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let fetchPodcast = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchPodcast.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            do {
                let podcasts = try context.fetch(fetchPodcast)
                
                print(podcasts)
            } catch {}
        }
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
