//
//  Strings.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 03.04.2022.
//

import Foundation

internal enum L10n {
    internal enum Alert {
        internal static let success = "Данные сохранены"
        internal static let failure = "Не удалось загрузить данные"
        internal static let addName = "Добавьте имя, чтобы отправить сообщение"
    }
    internal enum Photo {
        internal static let takePhoto = "Сделать фото"
        internal static let openGallery = "Открыть галерею"
    }
    
    internal enum TextFieldPlaceholders {
        internal static let name = "ФИО"
        internal static let status = "Дополнительная информация"
        internal static let message = "Новое сообщение"
    }
    
    internal enum Themes {
        internal static let classic = "Classic"
        internal static let day = "Day"
        internal static let night = "Night"
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
    
    internal static let error = "Ошибка"
    internal static let warning = "Предупреждение"
    internal static let cancel = "Отменить"
    internal static let close = "Закрыть"
    internal static let ok = "Ок"
    internal static let renew = "Повторить"
    internal static let edit = "Редактировать"
    internal static let change = "Изменить"
    internal static let save = "Сохранить"
    internal static let profileTitle = "My profile"
    internal static let createNewChannel = "Создать новый канал"
    internal static let create = "Создать"
    internal static let unknownChannelName = "Unknown Channel Name"
    internal static let enterChannelName = "Enter Channel Name"
    internal static let enterName = "Enter Name"
}
