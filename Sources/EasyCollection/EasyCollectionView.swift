// Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

public class EasyCollectionView: UIView {

    public enum AutomaticSize {
        case none
        case fullWidthAutoHeight
        case autoWidthFullHeight
    }

    public var automaticItemSize: AutomaticSize = .none

    public var sections: [EasySection] = [] {
        didSet { collectionView.reloadData() }
    }

    private lazy var layout = UICollectionViewFlowLayout()
    private lazy var collectionView: UICollectionView = {
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(EasyCollectionCell.self)
        collectionView.register(EasyCollectionHostCell.self)
        collectionView.register(EasyCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(EasyCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()

    public var itemConfiguration: EasyItem.Configuration = .init()
    public var itemAnimations: EasyItem.Animations = .init()
    public var sectionConfiguration: EasySection.Configuration = .init()

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder: NSCoder) { nil }

    private func setupView() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    public func reloadData() {
        collectionView.reloadData()
    }
}

extension EasyCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch sections[section].header {
        case .none:
            return .zero
        case .title:
            let indexPath = IndexPath(row: 0, section: section)
            let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            return headerView.systemLayoutSizeFitting(
                CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        switch sections[section].footer {
        case .none:
            return .zero
        case .title:
            let indexPath = IndexPath(row: 0, section: section)
            let footerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionFooter, at: indexPath)
            return footerView.systemLayoutSizeFitting(
                CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = sections[indexPath.section]
        let configuration = (section.configuration ?? sectionConfiguration)

        let maxWidth = collectionView.bounds.width - configuration.insets.left - configuration.insets.right
        let maxHeight = collectionView.bounds.height - configuration.insets.top - configuration.insets.bottom

        switch automaticItemSize {
        case .none:
            break
        case .autoWidthFullHeight:
            return .init(width: 100, height: maxHeight)
        case .fullWidthAutoHeight:
            return .init(width: maxWidth, height: 100)
        }

        var size = configuration.itemSize.size(in: collectionView.bounds)
        size.width = min(maxWidth, size.width)
        size.height = min(maxHeight, size.height)
        return size
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return (sections[section].configuration ?? sectionConfiguration).insets
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (sections[section].configuration ?? sectionConfiguration).minimumLineSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (sections[section].configuration ?? sectionConfiguration).minimumInteritemSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.item]
        item.action?()
    }
}

extension EasyCollectionView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch section.header {
            case .none:
                return UICollectionReusableView()
            case .title(let title):
                let configuration = section.configuration ?? sectionConfiguration
                let headerView: EasyCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
                headerView.setInsets(configuration.headerInsets)
                headerView.label.text = title
                configuration.configureHeader?(headerView)
                return headerView
            }
        case UICollectionView.elementKindSectionFooter:
            switch section.footer {
            case .none:
                return UICollectionReusableView()
            case .title(let title):
                let configuration = section.configuration ?? sectionConfiguration
                let footerView: EasyCollectionFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
                footerView.setInsets(configuration.footerInsets)
                footerView.label.text = title
                configuration.configureFooter?(footerView)
                return footerView
            }
        default:
            return UICollectionReusableView()
        }
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section].items[indexPath.item]
        let configuration = item.configuration ?? itemConfiguration
        switch item.content {
        case .view(let view):
            let cell: EasyCollectionHostCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setView(view)
            cell.setConfiguration(configuration)
            return cell
        default:
            let cell: EasyCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.automaticItemSize = automaticItemSize
            cell.setConfiguration(configuration)
            cell.setAnimations(item.animations ?? itemAnimations)
            cell.setItem(item)
            configuration.configureCell?(cell)
            return cell
        }
    }
}
