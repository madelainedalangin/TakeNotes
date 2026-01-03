import SwiftUI
import SwiftData

@Model
class Folder {
    var id: UUID
    var name: String
    var icon: TagIcon
    var colorHex: String? = nil
    var sortOrder: Int
    var crearedAt: Date
    var updatedAt: Date
    var parent: Folder?
    @Relationship(deleteRule: .cascade, inverse: \Folder.parent)
    var childFolders: [Folder]
}
