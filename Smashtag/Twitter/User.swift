//
//  User.swift
//  Twitter
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation

// container to hold data about a Twitter user

public struct User: CustomStringConvertible
{
    public let screenName: String
    public let name: String
    public var profileImageURL: NSURL?
    public let verified: Bool
    public let id: String
    
    public var description: String {
        let v = verified ? " ✅" : ""
        return "@\(screenName) (\(name))\(v)"
    }

    // MARK: - Private Implementation

    init?(data: NSDictionary?) {
        guard let name = data?.valueForKeyPath(TwitterKey.Name) as? String else {
            return nil
        }
        
        guard let screenName = data?.valueForKeyPath(TwitterKey.ScreenName) as? String else {
            return nil
        }
        
        self.name = name
        self.screenName = screenName
        self.id = (data?.valueForKeyPath(TwitterKey.ID) as? String) ?? ""
        self.verified = (data?.valueForKeyPath(TwitterKey.Verified)?.boolValue) ?? false
        
        if let urlString = data?.valueForKeyPath(TwitterKey.ProfileImageURL) as? String {
            self.profileImageURL = NSURL(string: urlString)
        }
    }
    
    var asPropertyList: AnyObject {
        var dictionary = Dictionary<String,String>()
        dictionary[TwitterKey.Name] = self.name
        dictionary[TwitterKey.ScreenName] = self.screenName
        dictionary[TwitterKey.ID] = self.id
        dictionary[TwitterKey.Verified] = verified ? "YES" : "NO"
        dictionary[TwitterKey.ProfileImageURL] = profileImageURL?.absoluteString
        return dictionary
    }

    
    init() {
        screenName = "Unknown"
        name = "Unknown"
        verified = false
        id = ""
    }
    
    struct TwitterKey {
        static let Name = "name"
        static let ScreenName = "screen_name"
        static let ID = "id_str"
        static let Verified = "verified"
        static let ProfileImageURL = "profile_image_url"
    }
}
