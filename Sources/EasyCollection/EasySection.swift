// Copyright © 2021 Roman Blum. All rights reserved.

import Foundation
import UIKit

public class EasySection {

    public enum EasyDimension: Equatable {
        case absolute(CGFloat)
        case fractional(CGFloat)
    }

    public struct EasySize: Equatable {
        let width: EasyDimension
        let height: EasyDimension

        public init(width: EasyDimension, height: EasyDimension) {
            self.width = width
            self.height = height
        }

        func size(in frame: CGRect) -> CGSize {
            let w: CGFloat
            switch width {
            case .absolute(let value):
                w = value
            case .fractional(let value):
                w = frame.width * value
            }

            let h: CGFloat
            switch height {
            case .absolute(let value):
                h = value
            case .fractional(let value):
                h = frame.height * value
            }

            return .init(width: w, height: h)
        }
    }

    public struct Configuration {
        public var itemSize: EasySize
        public var scrollDirection: UICollectionView.ScrollDirection
        public var minimumLineSpacing: CGFloat
        public var minimumInteritemSpacing: CGFloat
        public var insets: UIEdgeInsets
        public var headerInsets: UIEdgeInsets
        public var footerInsets: UIEdgeInsets

        public var configureHeader: ((EasyCollectionHeaderView) -> Void)?
        public var configureFooter: ((EasyCollectionFooterView) -> Void)?

        public init(
            itemSize: EasySize = .init(width: .absolute(80), height: .absolute(80)),
            scrollDirection: UICollectionView.ScrollDirection = .horizontal,
            minimumLineSpacing: CGFloat = 0.0,
            minimumInteritemSpacing: CGFloat = 0.0,
            insets: UIEdgeInsets = .zero,
            headerInsets: UIEdgeInsets = .zero,
            footerInsets: UIEdgeInsets = .zero,
            configureHeader: ((EasyCollectionHeaderView) -> Void)? = nil,
            configureFooter: ((EasyCollectionFooterView) -> Void)? = nil
        ) {
            self.itemSize = itemSize
            self.scrollDirection = scrollDirection
            self.minimumLineSpacing = minimumLineSpacing
            self.minimumInteritemSpacing = minimumInteritemSpacing
            self.insets = insets
            self.headerInsets = headerInsets
            self.footerInsets = footerInsets
            self.configureHeader = configureHeader
            self.configureFooter = configureFooter
        }

        public static let `default` = Configuration()
    }

    public let identifier: String
    public var header: Style
    public var items: [EasyItem]
    public var footer: Style
    public var configuration: Configuration?

    public init(identifier: String? = nil, header: Style = .none, items: [EasyItem], footer: Style = .none, configuration: Configuration? = nil) {
        self.identifier = identifier ?? UUID().uuidString
        self.header = header
        self.items = items
        self.footer = footer
        self.configuration = configuration
    }

    public enum Style {
        case none
        case title(String)
    }
}
