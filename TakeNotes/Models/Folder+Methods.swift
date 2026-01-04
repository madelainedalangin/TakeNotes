import SwiftData

extension Folder {
    func rename(to newName: String) {
        name = newName
        updateAt = Date()
    }
    
    func move(to newParent: Folder?) {
        if let newParent = newParent {
            if newParent.id == self.id || isAncestor(of: newParent){
                return //bc it's an invalid move
                
            }
        }
        if let oldParent = parent {
            oldParent.childFolders?.remove(at: oldParent.childFolders!.firstIndex(of: self)!)
        }
        
        parent = newParent
        
        if let newParent = newParent {
            if newParent.childFolders == nil {
                newParent.childFolders = []
            }
            newParent.childFolders?.append(self)
        }
        
        updatedAt = Date()
    }
    
    func createChild(
        name: String,
        icon
    )
}
