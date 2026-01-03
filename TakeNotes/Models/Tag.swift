import SwiftUI
import SwiftData

@Model
class Tag {

    var id: UUID
    var name: String
    var fullPath: String
    var icon: TagIcon
    var colorHex: String?
    var isPinned: Bool
    var sortOrder: Int      //Sort order within parent
    var createdAt: Date
    var updatedAt: Date
    var parent: Tag?        //Parent tag (nil if root-level)
    
    // Child tags (.cascade = delete children when parent deleted)
    @Relationship(deleteRule: .cascade, inverse: \Tag.parent)
    var children: [Tag]?
    
    init(
        name: String,
        fullPath: String? = nil,
        parent: Tag? = nil,
        icon: TagIcon = .none,
        colorHex: String? = nil,
        isPinned: Bool = false,
        sortOrder: Int = 0
    ) {
        self.id = UUID()
        self.name = name
        self.fullPath = fullPath ?? name
        self.parent = parent
        self.icon = icon
        self.colorHex = colorHex
        self.isPinned = isPinned
        self.sortOrder = sortOrder
        self.createdAt = Date()
        self.updatedAt = Date()
        self.children = []
    }
}
