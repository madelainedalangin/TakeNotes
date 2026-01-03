import SwiftData

extension Tag {
    static func createSampleTags(in context: ModelContext) {
        
        let work = Tag(name: "work", icon: .emoji("💼"), isPinned: true)
        let personal = Tag(name: "personal", icon: .emoji("🏠"))
        let ideas = Tag(name: "ideas", icon: .emoji("💡"))
        
        context.insert(work)
        context.insert(personal)
        context.insert(ideas)
        
        let design = work.createChild(name: "design", icon: .emoji("🎨"))
        let meetings = work.createChild(name: "meetings", icon: .emoji("📅"))
        let _ = work.createChild(name: "tasks", icon: .sfSymbol("checklist"))

        let _ = design.createChild(name: "ui", icon: .sfSymbol("paintbrush"))
        let _ = design.createChild(name: "branding", icon: .sfSymbol("star"))
        
        let _ = personal.createChild(name: "fitness", icon: .emoji("🏋️"))
        let _ = personal.createChild(name: "reading", icon: .emoji("📚"))
        let _ = personal.createChild(name: "recipes", icon: .emoji("🍳"))
        
        context.insert(design)
        context.insert(meetings)
    }
}
