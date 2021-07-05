// Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

final class EasyCollectionHostCell: UICollectionViewCell, ReusableView {

    private var leftPaddingConstraint = NSLayoutConstraint()
    private var rightPaddingConstraint = NSLayoutConstraint()
    private var topPaddingConstraint = NSLayoutConstraint()
    private var bottomPaddingConstraint = NSLayoutConstraint()

    private lazy var innerContentView = UIView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCell()
    }

    required init?(coder: NSCoder) { nil }

    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }

    func setConfiguration(_ configuration: EasyItem.Configuration) {
        leftPaddingConstraint.constant = configuration.padding.left
        rightPaddingConstraint.constant = configuration.padding.right
        topPaddingConstraint.constant = configuration.padding.top
        bottomPaddingConstraint.constant = configuration.padding.bottom

        layer.cornerRadius = configuration.cornerRadius
        clipsToBounds = true
    }

    func setView(_ view: UIView) {
        resetCell()
        
        innerContentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: innerContentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: innerContentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: innerContentView.bottomAnchor),
            view.topAnchor.constraint(equalTo: innerContentView.topAnchor)

        ])
    }

    private func setupCell() {
        contentView.addSubview(innerContentView)
        innerContentView.translatesAutoresizingMaskIntoConstraints = false

        leftPaddingConstraint = innerContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        rightPaddingConstraint = innerContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        bottomPaddingConstraint = innerContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        topPaddingConstraint = innerContentView.topAnchor.constraint(equalTo: contentView.topAnchor)

        NSLayoutConstraint.activate([
            leftPaddingConstraint, rightPaddingConstraint, bottomPaddingConstraint, topPaddingConstraint
        ])
    }

    private func resetCell() {
        innerContentView.subviews.forEach { $0.removeFromSuperview() }
    }
}
