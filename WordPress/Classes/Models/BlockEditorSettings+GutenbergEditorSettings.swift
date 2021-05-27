import Foundation
import WordPressKit
import Gutenberg

extension BlockEditorSettings: GutenbergEditorSettings {
    public var colors: [[String: String]]? {
        elementsByType(.color)
    }

    public var gradients: [[String: String]]? {
        elementsByType(.gradient)
    }

    private func elementsByType(_ type: BlockEditorSettingElementTypes) -> [[String: String]]? {
        return elements?.compactMap({ (element) -> [String: String]? in
            guard element.type == type.rawValue else { return nil }
            return element.rawRepresentation
        })
    }
}

extension BlockEditorSettings {
    convenience init?(editorTheme: RemoteEditorTheme, context: NSManagedObjectContext) {
        self.init(context: context)
        self.isFSETheme = false
        self.lastUpdated = Date()
        self.checksum = editorTheme.checksum

        var parsedElements = Set<BlockEditorSettingElement>()
        if let themeSupport = editorTheme.themeSupport {
            themeSupport.colors?.forEach({ (color) in
                parsedElements.insert(BlockEditorSettingElement(fromRawRepresentation: color, type: .color, context: context))
            })

            themeSupport.gradients?.forEach({ (gradient) in
                parsedElements.insert(BlockEditorSettingElement(fromRawRepresentation: gradient, type: .gradient, context: context))
            })
        }

        self.elements = parsedElements
    }

    convenience init?(remoteSettings: RemoteBlockEditorSettings, context: NSManagedObjectContext) {
        self.init(context: context)
        self.isFSETheme = remoteSettings.isFSETheme
        self.lastUpdated = Date()
        self.checksum = remoteSettings.checksum
        self.rawStyles = remoteSettings.rawStyles
        var parsedElements = Set<BlockEditorSettingElement>()

        remoteSettings.colors?.forEach({ (color) in
            parsedElements.insert(BlockEditorSettingElement(fromRawRepresentation: color, type: .color, context: context))
        })

        remoteSettings.gradients?.forEach({ (gradient) in
            parsedElements.insert(BlockEditorSettingElement(fromRawRepresentation: gradient, type: .gradient, context: context))
        })

        self.elements = parsedElements
    }
}
