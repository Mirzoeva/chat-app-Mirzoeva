//
//  Strings.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 03.04.2022.
//

import UIKit

internal enum L10n {
    internal enum Alert {
        internal static let success = "Data saved"
        internal static let failure = "Failed to load data"
        internal static let addName = "Add a name to send a message"
    }
    internal enum Photo {
        internal static let takePhoto = "Take a photo"
        internal static let openGallery = "Open gallery"
        internal static let deletePhoto = "Delete Photo"
    }
    
    internal enum TextFieldPlaceholders {
        internal static let name = "Name"
        internal static let status = "BIO"
        internal static let message = "New message"
    }
    
    internal enum Themes {
        internal static let classic = "Classic"
        internal static let day = "Day"
        internal static let night = "Night"
    }
    
    internal enum Images {
        static let placeholder = UIImage(named: "avatar-placeholder")
    }
    
    internal enum Firebase {
        internal static let channels = "channels"
        internal static let messages = "messages"
    }
    
    internal enum CoreData {
        internal static let DBChannel = "DBChannel"
        internal static let DBMessage = "DBMessage"
        internal static let lastActivity = "lastActivity"
        internal static let lastMessage = "lastMessage"
        internal static let name = "name"
        internal static let created = "created"
        internal static let content = "content"
        internal static let senderId = "senderId"
        internal static let senderName = "senderName"
    }
    
    internal static let error = "Error"
    internal static let warning = "Warning"
    internal static let cancel = "Cancel"
    internal static let close = "Close"
    internal static let ok = "Ок"
    internal static let renew = "Retry"
    internal static let edit = "Edit"
    internal static let change = "Change"
    internal static let save = "Save"
    internal static let profileTitle = "My profile"
    internal static let createNewChannel = "Create a new channel"
    internal static let create = "Create"
    internal static let unknownChannelName = "Unknown Channel Name"
    internal static let enterChannelName = "Enter Channel Name"
    internal static let enterName = "Enter Name"
}
