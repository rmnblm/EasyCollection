//  Copyright © 2020 Roman Blum. All rights reserved.

import UIKit

public final class EasyCollectionHeaderView: UICollectionReusableView, ReusableView {

    private var leftPaddingConstraint = NSLayoutConstraint()
    private var rightPaddingConstraint = NSLayoutConstraint()
    private var topPaddingConstraint = NSLayoutConstraint()
    private var bottomPaddingConstraint = NSLayoutConstraint()

    public private(set) lazy var label: UILabel = {
        let label = UILabel()
        if #available(iOS 13.0, tvOS 13.0, *) {
            label.textColor = .secondaryLabel
        }
        else {
            label.textColor = .gray
        }
        #if os(iOS)
        label.font = .systemFont(ofSize: 16)
        #endif
        #if os(tvOS)
        label.font = .systemFont(ofSize: 30)
        #endif
        return label
    }()

    public override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }

    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    required public init?(coder: NSCoder) { nil }

    func setInsets(_ insets: UIEdgeInsets) {
        leftPaddingConstraint.constant = insets.left
        rightPaddingConstraint.constant = insets.right
        topPaddingConstraint.constant = insets.top
        bottomPaddingConstraint.constant = insets.bottom
    }

    func setupView() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        leftPaddingConstraint = label.leadingAnchor.constraint(equalTo: leadingAnchor)
        leftPaddingConstraint.priority = .init(rawValue: 999)
        rightPaddingConstraint = label.trailingAnchor.constraint(equalTo: trailingAnchor)
        rightPaddingConstraint.priority = .init(rawValue: 999)
        bottomPaddingConstraint = label.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottomPaddingConstraint.priority = .init(rawValue: 999)
        topPaddingConstraint = label.topAnchor.constraint(equalTo: topAnchor)
        topPaddingConstraint.priority = .init(rawValue: 999)

        NSLayoutConstraint.activate([
            leftPaddingConstraint, rightPaddingConstraint, bottomPaddingConstraint, topPaddingConstraint
        ])
    }
}
