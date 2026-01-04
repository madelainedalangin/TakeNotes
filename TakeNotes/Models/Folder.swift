import SwiftUI
import SwiftData

@Model
class Folder {
    var id: UUID
    var name: String
    var icon: TagIcon
    var colorHex: String? = nil
    var sortOrder: Int
    var createdAt: Date
    var updatedAt: Date
    var parent: Folder?
    @Relationship(deleteRule: .cascade, inverse: \Folder.parent)
    var childFolders: [Folder]?
    
    init(id: UUID, name: String, icon: TagIcon, colorHex: String? = nil, sortOrder: Int, createdAt: Date, updatedAt: Date, parent: Folder? = nil, childFolders: [Folder]? = nil) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
        self.sortOrder = sortOrder
        self.createdAt = Date()
        self.updatedAt = Date()
        self.parent = parent
        self.childFolders = []
    }
    var isRoot: Bool {
        parent == nil
    }
    //Nesting depth (0 = root)
    var depth: Int {
        var count = 0
        var current = parent
        while current != nil {
            count += 1
            current = current?.parent
        }
        return count
    }
    var hasChildren: Bool {
        childFolders?.count ?? 0 > 0
    }
    var childFoldersCount: Int {
        childFolders?.count ?? 0
    }
    var fullPath: String {
        if let parent = parent {
            return "\(parent.fullPath)/\(name)"
        }
        return name
    }
    var color: Color? {
        guard let hex = colorHex else { return nil }
        return Color(hex: hex)
    }
}
