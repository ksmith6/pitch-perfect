//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Kelly Smith on 6/2/15.
//  Copyright (c) 2015 Kelly Smith. All rights reserved.
//
// Images made by FreePik from www.flaticon.com

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title       = title
    }
    
}