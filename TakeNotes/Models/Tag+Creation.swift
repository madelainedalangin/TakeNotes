import SwiftData

extension Tag {
    
    func createChild(
        name: String,
        icon: TagIcon = .none,
        colorHex: String? = nil
    ) -> Tag {
        let childPath = "\(fullPath)/\(name)"
        let child = Tag(
            name: name,
            fullPath: childPath,
            parent: self,
            icon: icon,
            colorHex: colorHex,
            sortOrder: childCount
        )
        
        if children == nil {
            children = []
        }
        children?.append(child)
        
        return child
    }
    
    static func createFromPath(
        _ path: String,
        icon: TagIcon = .none,
        in context: ModelContext,
        existingTags: [Tag]
    ) -> Tag {
        let components = path.split(separator: "/").map(String.init)
        
        var currentParent: Tag? = nil
        var currentPath = ""
        var lastTag: Tag? = nil
        
        for (index, component) in components.enumerated() {
            currentPath = currentPath.isEmpty ? component : "\(currentPath)/\(component)"
        
            if let existing = existingTags.first(where: { $0.fullPath == currentPath }) {
                currentParent = existing
                lastTag = existing
            } else {
                let isLast = index == components.count - 1
                let newTag = Tag(
                    name: component,
                    fullPath: currentPath,
                    parent: currentParent,
                    icon: isLast ? icon : .none
                )
                if let parent = currentParent {
                    if parent.children == nil {
                        parent.children = []
                    }
                    parent.children?.append(newTag)
                }
                
                context.insert(newTag)
                currentParent = newTag
                lastTag = newTag
            }
        }
        
        return lastTag!
    }
}
