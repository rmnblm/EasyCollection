// Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

public class EasyItem {

    public struct Icon {
        public let image: UIImage?
        public let highlightedImage: UIImage?

        public init(image: UIImage?, highlightedImage: UIImage? = nil) {
            self.image = image
            self.highlightedImage = highlightedImage
        }
    }

    public struct Configuration {
        public var padding: UIEdgeInsets
        public var cornerRadius: CGFloat
        public var backgroundColor: UIColor
        public var alpha: CGFloat

        public var configureCell: ((EasyCollectionCell) -> Void)?

        public init(
            padding: UIEdgeInsets = .init(top: 8, left: 15, bottom: -8, right: -15),
            cornerRadius: CGFloat = 0.0,
            backgroundColor: UIColor = .clear,
            alpha: CGFloat = 1.0,
            configureCell: ((EasyCollectionCell) -> Void)? = nil
        ) {
            self.padding = padding
            self.cornerRadius = cornerRadius
            self.backgroundColor = backgroundColor
            self.alpha = alpha
            self.configureCell = configureCell
        }
    }

    public enum Animation {
        case scale(x: CGFloat = 1.0, y: CGFloat = 1.0, concatenated: Bool = false)
        case background(UIColor)
        case alpha(CGFloat)

        case resetScale
        case resetBackground
        case resetAlpha

        func makeAnimation(_ view: UIView, using configuration: Configuration) -> (() -> Void) {
            switch self {
            case .scale(let x, let y, let concatenated):
                if concatenated {
                    return { view.transform = view.transform.scaledBy(x: x, y: y) }
                }
                return { view.transform = .init(scaleX: x, y: y) }
            case .background(let color):
                return { view.backgroundColor = color }
            case .alpha(let value):
                return { view.alpha = value }
            case .resetScale:
                return { view.transform = .identity }
            case .resetBackground:
                return { view.backgroundColor = configuration.backgroundColor }
            case .resetAlpha:
                return { view.alpha = configuration.alpha }
            }
        }
    }

    public struct Animations {
        public var becomeFocused: [Animation]
        public var resignFocus: [Animation]
        public var pressIn: [Animation]
        public var pressOut: [Animation]
        public var touchIn: [Animation]
        public var touchOut: [Animation]

        public init(
            becomeFocused: [Animation] = [],
            resignFocus: [Animation] = [],
            pressIn: [Animation] = [],
            pressOut: [Animation] = [],
            touchIn: [Animation] = [],
            touchOut: [Animation] = []
        ) {
            self.becomeFocused = becomeFocused
            self.resignFocus = resignFocus
            self.pressIn = pressIn
            self.pressOut = pressOut
            self.touchIn = touchIn
            self.touchOut = touchOut
        }
    }

    public typealias TapActionHandler = () -> Void

    public let identifier: String
    public var content: Content
    public var icon: Icon?
    public var animations: Animations?
    public var configuration: Configuration?
    public var action: TapActionHandler?

    public init(
        _ content: Content,
        identifier: String? = nil,
        icon: Icon? = nil,
        animations: Animations? = nil,
        configuration: Configuration? = nil,
        action: TapActionHandler? = nil
    ) {
        self.identifier = identifier ?? UUID().uuidString
        self.content = content
        self.icon = icon
        self.animations = animations
        self.configuration = configuration
        self.action = action
    }

    public enum Content {
        case text(String, numberOfLines: Int = 1)
        case subtitle(title: String, subtitle: String?)
        case value(title: String, value: String?)
        case view(UIView)
    }
}
