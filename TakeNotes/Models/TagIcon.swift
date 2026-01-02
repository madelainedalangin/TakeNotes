/*
 TagIcon.swift handles the use of icons on tags for the sake of ✨aesthetic✨.
 */

import SwiftUI

enum TagIcon: Equatable, Hashable {
    case emoji(String)
    case sfSymbol(String) //free icon library
    case custom(Data)
    case none
    
    var hasIcon: Bool {
        if case .none = self {
            return false
        }
        return true
    }
    
    var emojiValue: String? {
        if case .emoji(let value) = self {
            return value
        }
        return nil
    }
    
    var customUpload: Data? {
        if case .custom(let data) = self {
            return data
        }
        return nil
    }
}

extension TagIcon: Codable{
    private enum CodingKeys: String, CodingKey {
        case type
        case value
    }
    
    private enum IconType: String, Codable{
        case emoji
        case sfSymbol
        case custom
        case none
    }
    
    func encode (to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .emoji(let value):
            try container .encode(IconType.emoji, forKey: .type)
            try container .encode(value, forKey: .value)
            
        case .sfSymbol(let value):
            try container .encode(IconType.sfSymbol, forKey: .type)
            try container .encode(value, forKey: .value)
            
        case .custom(let data):
            try container .encode(IconType.custom, forKey: .type)
            try container .encode(data, forKey: .value)
            
        case .none:
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(IconType.self, forKey: .type)
        
        switch type {
            
        case .emoji:
            let value = try container.decode(String.self, forKey: .value)
            let valueData = value.data(using: .utf8)!
            self = .emoji(String(data: valueData, encoding: .utf8)!)
            
        case .sfSymbol:
            let value = try container.decode(String.self, forKey: .value)
            let valueData = value.data(using: .utf8)!
            self = .sfSymbol(value)
            
        case .custom:
            let value = try container.decode(Data.self, forKey: .value)
            self = .custom(value)
    
        case .none:
            self = .none
        }
    }
}

extension TagIcon {
    @ViewBuilder
    func iconView(size: CGFloat = 16) -> some View {
        switch self {
        case .emoji(let value):
            Text(value)
                .font(.system(size: size))
            
        case .sfSymbol(let name):
            Image(systemName: name)
                .font(.system(size: size))
            
        case .custom(let data):
            if let image = platformImage(from: data) {
                #if os(macOS)
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                #else
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                #endif
            } else {
                Image(systemName: "questionmark.square")
                    .font(.system(size: size))
            }
            
        case .none:
            EmptyView()
        }
    }

    #if os(macOS)
    private func platformImage(from data: Data) -> NSImage? {
        return NSImage(data: data)
    }
    #else
    private func platformImage(from data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    #endif
}

extension TagIcon {
    
    //Default
    static let folder = TagIcon.emoji("📁")
    static let home = TagIcon.emoji("🏠")
    static let work = TagIcon.emoji("💼")
    static let star = TagIcon.emoji("⭐")
    static let heart = TagIcon.emoji("❤️")
    static let book = TagIcon.emoji("📚")
    static let idea = TagIcon.emoji("💡")
    static let flag = TagIcon.emoji("🚩")
    
    // Common SF Symbol Presets
    static let sfFolder = TagIcon.sfSymbol("folder.fill")
    static let sfTag = TagIcon.sfSymbol("tag.fill")
    static let sfStar = TagIcon.sfSymbol("star.fill")
    static let sfBookmark = TagIcon.sfSymbol("bookmark.fill")
    static let sfHeart = TagIcon.sfSymbol("heart.fill")
    static let sfFlag = TagIcon.sfSymbol("flag.fill")
    static let sfArchive = TagIcon.sfSymbol("archivebox.fill")
    static let sfTrash = TagIcon.sfSymbol("trash.fill")
}
