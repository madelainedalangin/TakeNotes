
import Foundation

extension Tag {
    func updateFullPath() {
        if let parent = parent {
            fullPath = "\(parent.fullPath)/\(name)"
        } else {
            fullPath = name
        }
        updatedAt = Date()
        children?.forEach { $0.updateFullPath() }
    }

    func rename(to newName: String) {
        name = newName
        updateFullPath()
    }

    func move(to newParent: Tag?) {
        if let oldParent = parent {
            oldParent.children?.removeAll { $0.id == self.id }
        }
        parent = newParent
        if let newParent = newParent {
            if newParent.children == nil {
                newParent.children = []
            }
            newParent.children?.append(self)
        }
        
        updateFullPath()
    }
    
    func ancestors() -> [Tag] {
        var result: [Tag] = []
        var current = parent
        while let tag = current {
            result.append(tag)
            current = tag.parent
        }
        return result.reversed()
    }

    func descendants() -> [Tag] {
        var result: [Tag] = []
        for child in children ?? [] {
            result.append(child)
            result.append(contentsOf: child.descendants())
        }
        return result
    }

    func isAncestor(of tag: Tag) -> Bool {
        var current = tag.parent
        while let t = current {
            if t.id == self.id { return true }
            current = t.parent
        }
        return false
    }
    func isDescendant(of tag: Tag) -> Bool {
        tag.isAncestor(of: self)
    }
}
