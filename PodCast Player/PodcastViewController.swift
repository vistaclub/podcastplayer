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
    var episodesVC : EpisodesViewController? = nil
    
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // podcastURLTextField.stringValue = "http://www.espn.com/espnradio/podcast/feeds/itunes/podCast?id=2406595"
        podcastURLTextField.stringValue = ""
        getPodcasts()
    }
    
    func getPodcasts() {
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let fetchPodcast = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchPodcast.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            do {
                podcasts = try context.fetch(fetchPodcast)
                
                print(podcasts)
            } catch {}
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addButtonClicked(_ sender: AnyObject) {
        
        if let url = URL(string: podcastURLTextField.stringValue) {
            
            // URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
            URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
                
                if error != nil {
                    print(error as Any)
                } else {
                    if data != nil {
                        let parser = Parser()
                        let info = parser.getPodcastMetaData(data: data!)
                        
                        if !self.podcastExists(rssURL: self.podcastURLTextField.stringValue) {
                            
                            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                                let podcast = Podcast(context: context)
                                
                                podcast.rssURL = self.podcastURLTextField.stringValue
                                podcast.imageURL = info.imageURL
                                podcast.title = info.title
                                
                                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                                
                                self.getPodcasts()
                                
                                DispatchQueue.main.async {
                                    self.podcastURLTextField.stringValue = ""
                                }
                            }
                        }
                    }
                }
                }.resume()
        }
    }
    
    func podcastExists(rssURL:String) -> Bool {
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let fetchPodcast = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchPodcast.predicate = NSPredicate(format: "rssURL == %@", rssURL)
            
            do {
                let matchingPodcasts = try context.fetch(fetchPodcast)
                
                if matchingPodcasts.count >= 1 {
                    return true
                } else {
                    return false
                }
            } catch {}
            
        }
        return false
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
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        if tableView.selectedRow >= 0 {
            let podcast = podcasts[tableView.selectedRow]
            episodesVC?.podcast = podcast
            episodesVC?.updateView()
        }
    }
}
