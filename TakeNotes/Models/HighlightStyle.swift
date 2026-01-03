/*
 HighlightStyle.swift handles text highlights.
 */
import SwiftUI

enum GradientDirection: String, Codable, CaseIterable {
    case topToBottom
    case bottomToTop
    case leftToRight
    case rightToLeft
    case diagonalDown
    case diagonalUp
    
    var startPoint: UnitPoint {
        switch self {
        case .topToBottom:
            return .topLeading
        case .bottomToTop:
            return .bottomLeading
        case .leftToRight:
            return .topLeading
        case .rightToLeft:
            return .topTrailing
        case .diagonalUp:
            return .topLeading
        case .diagonalDown:
            return .bottomLeading
        }
    }
    
    var endPoint: UnitPoint {
        switch self {
        case .leftToRight: return .trailing
        case .rightToLeft: return .leading
        case .topToBottom: return .bottom
        case .bottomToTop: return .top
        case .diagonalUp: return .bottomTrailing
        case .diagonalDown: return .topTrailing
        }
    }
}

enum HighlightStyle: Equatable, Hashable{
    
    case none
    case solid(colorHex: String, opacity: Double)
    case gradient(startColorHex: String, endColorHex: String, direction: GradientDirection, opacity: Double)
    
    var isNone: Bool {
        switch self {
        case .none: return true
        default: return false
        }
    }
    var isSolid: Bool {
        if case .solid = self {
            return true
        } else {
            return false
        }
    }
    
    var isGradient: Bool {
        if case .gradient = self {
            return true
        } else {
            return false
        }
    }
    
    var opacity: Double {
        switch self {
        case .none: return 0.0
        case .solid(colorHex: _, opacity: let opacity): return opacity
        case .gradient(startColorHex: _, endColorHex: _, direction: _, opacity: let opacity): return opacity
        }
    }
}

extension HighlightStyle: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case colorHex
        case startColorHex
        case endColorHex
        case direction
        case opacity
    }
    private enum StyleType: String, Codable {
        case none
        case solid
        case gradient
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .none:
            try container.encode(StyleType.none, forKey: .type)
        case .solid(let colorHex, let opacity):
            try container.encode(StyleType.solid, forKey: .type)
            try container.encode(colorHex, forKey: .colorHex)
            try container.encode(opacity, forKey: .opacity)
        case .gradient(let startHex, let endHex, direction: let direction, opacity: let opacity):
            try container.encode(StyleType.gradient, forKey: .type)
            try container.encode(startHex, forKey: .startColorHex)
            try container.encode(endHex, forKey: .endColorHex)
            try container.encode(direction, forKey: .direction)
            try container.encode(opacity, forKey: .opacity)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(StyleType.self, forKey: .type)
        switch type {
        case .none:
            self = .none
        case .solid:
            let colorHex = try container.decode(String.self, forKey: .colorHex)
            let opacity = try container.decode(Double.self, forKey: .opacity)
            self = .solid(colorHex: <#T##String#>, opacity: <#T##Double#>)
        case .gradient:
            let startHex = try container.decode(String.self, forKey: .startColorHex)
            let endHex = try container.decode(String.self, forKey: .endColorHex)
            let direction: GradientDirection = try container.decode(GradientDirection.self, forKey: .direction)
            let opacity = try container.decode(Double.self, forKey: .opacity)
            self = .gradient(startColorHex: startHex, endColorHex: endHex, direction: direction, opacity: opacity)
        }
    }
}

extension HighlightStyle {
    
    @ViewBuilder
    func backgroundView() -> some View {
        switch self {
        case .none:
            Color.clear
        case .solid(let colorHex, let opacity):
            Color(hex: colorHex)
                .opacity(opacity)
        case .gradient(let startHex, let endHex, let direction, let opacity):
            LinearGradient(
                colors: [Color(hex: startHex), Color(hex: endHex)],
                startPoint: direction.startPoint,
                endPoint: direction.endPoint
            )
            .opacity(opacity)
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b, a: UInt64
        switch hex.count {
        case 6:
            (r, g, b, a) = (
                (int >> 16) & 0xFF,
                (int >> 8) & 0xFF,
                int & 0xFF,
                255
                )
        case 8:
            (r, g, b, a) = (
                (int >> 24) & 0xFF,
                (int >> 16) & 0xFF,
                (int >> 8) & 0xFF,
                int & 0xFF
            )
        default:
            (r, g, b, a) = (0, 0, 0, 255)
        }
        self .init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHex() -> String? {
        #if os(macOS)
        let nsColor = NSColor(self)
        guard let convertedColor = nsColor.usingColorSpace(.deviceRGB) else {
            return nil
        }
        let red = Int(convertedColor.redComponent * 255)
        let green = Int(convertedColor.greenComponent * 255)
        let blue = Int(convertedColor.blueComponent * 255)
        return String(format: "%02X%02X%02X", red, green, blue)
        #else
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
        #endif
    }
}

/*
 Preset Highlights
 */
extension HighlightStyle {
    
    //Solid
    static let yellowHighlight = HighlightStyle.solid(colorHex: "FFFF00", opacity: 0.5)
    static let greenHighlight = HighlightStyle.solid(colorHex: "90EE90", opacity: 0.5)
    static let blueHighlight = HighlightStyle.solid(colorHex: "87CEEB", opacity: 0.5)
    static let pinkHighlight = HighlightStyle.solid(colorHex: "FFB6C1", opacity: 0.5)
    static let orangeHighlight = HighlightStyle.solid(colorHex: "FFA500", opacity: 0.5)
    static let purpleHighlight = HighlightStyle.solid(colorHex: "DDA0DD", opacity: 0.5)
    
    /*
     Gradient
     */
    
    /// Warm sunrise gradient (orange → pink)
    static let sunrise = HighlightStyle.gradient(
        startColorHex: "FFE259",
        endColorHex: "FFA751",
        direction: .leftToRight,
        opacity: 0.6
    )
    
    /// Cool ocean gradient (blue → teal)
    static let ocean = HighlightStyle.gradient(
        startColorHex: "2193B0",
        endColorHex: "6DD5ED",
        direction: .leftToRight,
        opacity: 0.6
    )
    
    /// Bold berry gradient (purple → violet)
    static let berry = HighlightStyle.gradient(
        startColorHex: "8E2DE2",
        endColorHex: "4A00E0",
        direction: .leftToRight,
        opacity: 0.6
    )
    
    /// Fresh mint gradient (teal → green)
    static let mint = HighlightStyle.gradient(
        startColorHex: "11998E",
        endColorHex: "38EF7D",
        direction: .leftToRight,
        opacity: 0.6
    )
    
    /// Soft peach gradient (peach → coral)
    static let peach = HighlightStyle.gradient(
        startColorHex: "FFB199",
        endColorHex: "FF0844",
        direction: .leftToRight,
        opacity: 0.5
    )
    
    /// Lavender dream gradient (purple → pink)
    static let lavender = HighlightStyle.gradient(
        startColorHex: "C471F5",
        endColorHex: "FA71CD",
        direction: .leftToRight,
        opacity: 0.5
    )
    
    /// Fire gradient (red → orange)
    static let fire = HighlightStyle.gradient(
        startColorHex: "F83600",
        endColorHex: "F9D423",
        direction: .leftToRight,
        opacity: 0.5
    )
    
    /// All gradient presets for picker UI
    static let allGradientPresets: [HighlightStyle] = [
        .sunrise, .ocean, .berry, .mint, .peach, .lavender, .fire
    ]
    
    /// All solid presets for picker UI
    static let allSolidPresets: [HighlightStyle] = [
        .yellowHighlight, .greenHighlight, .blueHighlight,
        .pinkHighlight, .orangeHighlight, .purpleHighlight
    ]
}
