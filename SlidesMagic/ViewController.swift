/*
* ViewController.swift
* SlidesMagic
*
* Created by Gabriel Miro on 7/11/15.
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Cocoa

class ViewController: NSViewController {
  
  let imageDirectoryLoader = ImageDirectoryLoader()

    @IBOutlet weak var collectionView: NSCollectionView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    let initialFolderUrl = NSURL.fileURLWithPath("/Library/Desktop Pictures", isDirectory: true)
    imageDirectoryLoader.loadDataForFolderWithUrl(initialFolderUrl)
    
    configureCollectionView()
    collectionView.reloadData()
  }
  
  func loadDataForNewFolderWithUrl(folderURL: NSURL) {
    imageDirectoryLoader.loadDataForFolderWithUrl(folderURL)
    
  }

  
  private func configureCollectionView() {
    let flowLayout = NSCollectionViewFlowLayout()
    flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
    flowLayout.sectionInset = NSEdgeInsets(top: 30.0, left: 20.0, bottom: 30.0, right: 20.0)
    flowLayout.minimumInteritemSpacing = 20.0
    flowLayout.minimumLineSpacing = 20.0
    collectionView.collectionViewLayout = flowLayout
    view.wantsLayer = true;
    
    collectionView.layer?.backgroundColor = NSColor.blackColor().CGColor
  }
}


extension ViewController : NSCollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
      return imageDirectoryLoader.numberOfSections
    }
  
    func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
      return imageDirectoryLoader.numberOfItemsInSection(section)
    }
    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
      let item = collectionView.makeItemWithIdentifier("CollectionViewItem", forIndexPath: indexPath)
      guard let collectionViewItem = item as? CollectionViewItem else { return item }
      let imageFile = imageDirectoryLoader.imageFileForIndexPath(indexPath)
      collectionViewItem.imageFile = imageFile
      
      if let selectedIndexPath = collectionView.selectionIndexPaths.first where selectedIndexPath == indexPath {
        collectionViewItem.setHighlight(true)
      } else {
        collectionViewItem.setHighlight(false)
      }
      return item
    }
  
  func collectionView(collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> NSView {
    let view = collectionView.makeSupplementaryViewOfKind(NSCollectionElementKindSectionHeader, withIdentifier: "HeaderView", forIndexPath: indexPath) as! HeaderView
    view.sectionTitle.stringValue = "Section \(indexPath.section)"
    let numberOfItemInSectoin = imageDirectoryLoader.numberOfItemsInSection(indexPath.section)
    view.imageCount.stringValue = "\(numberOfItemInSectoin) image files"
    return view;
  }
  
    @IBAction func showHideSections(sender: NSButton) {
      let show  = sender.state
      imageDirectoryLoader.singleSectionMode = (show == NSOffState)
      imageDirectoryLoader.setupDataForUrls(nil)
      
      collectionView.reloadData()
    }
  func collectionView(collectionView: NSCollectionView, didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>) {
    guard let indexPath = indexPaths.first else {
      return
    }
    
    guard let item = collectionView.itemAtIndexPath(indexPath) else {
      return
    }
    
    (item as! CollectionViewItem).setHighlight(true)
    
  }
  
  
  func collectionView(collectionView: NSCollectionView, didDeselectItemsAtIndexPaths indexPaths: Set<NSIndexPath>) {
    guard let indexPath = indexPaths.first else {
      return
    }
    
    guard let item = collectionView.itemAtIndexPath(indexPath) else {
      return
    }
    
    (item as! CollectionViewItem).setHighlight(false)
  }
}


extension ViewController : NSCollectionViewDelegateFlowLayout {
  func collectionView(collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
    return imageDirectoryLoader.singleSectionMode ? NSZeroSize : NSSize(width: 1000, height: 40)
  }
}
