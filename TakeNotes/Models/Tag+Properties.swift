import SwiftUI

extension Tag {
    var isRoot: Bool {
        parent == nil
    }
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
        !(children?.isEmpty ?? true)
    }
    var childCount: Int {
        children?.count ?? 0
    }
    
    var displayIcon: TagIcon {
        if icon.hasIcon {
            return icon
        }
        if let parentIcon = parent?.displayIcon, parentIcon.hasIcon {
            return parentIcon
        }
        return .sfSymbol("number")
    }
    
    var color: Color? {
        guard let hex = colorHex else { return nil }
        return Color(hex: hex)
    }
    
    // Format for display: "#school/winter26"
    var displayTag: String {
        "#\(fullPath)"
    }
}
