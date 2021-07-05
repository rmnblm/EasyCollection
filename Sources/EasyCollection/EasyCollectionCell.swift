// Copyright © 2021 Roman Blum. All rights reserved.

import UIKit

public final class EasyCollectionCell: UICollectionViewCell, ReusableView {

    var automaticItemSize: EasyCollectionView.AutomaticSize = .none

    private lazy var innerContentView = UIView()

    #if os(iOS)
    private lazy var separatorLine = UIView()
    #endif

    public private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        if #available(iOS 13.0, tvOS 13.0, *) {
            label.textColor = .label
        }
        else {
            label.textColor = .black
        }
        return label
    }()

    public private(set) lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        if #available(iOS 13.0, tvOS 13.0, *) {
            label.textColor = .secondaryLabel
        }
        else {
            label.textColor = .gray
        }
        label.numberOfLines = 0
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 2.0
        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()

    private var hasAction: Bool = false
    private var configuration: EasyItem.Configuration = .init()
    private var animations: EasyItem.Animations = .init()

    private var leftPaddingConstraint = NSLayoutConstraint()
    private var rightPaddingConstraint = NSLayoutConstraint()
    private var topPaddingConstraint = NSLayoutConstraint()
    private var bottomPaddingConstraint = NSLayoutConstraint()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCell()
    }

    required init?(coder: NSCoder) { nil }

    public override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }

    public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        switch automaticItemSize {
        case .none:
            break
        case .fullWidthAutoHeight:
            layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        case .autoWidthFullHeight:
            layoutAttributes.bounds.size.width = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
        }
        return layoutAttributes
    }

    private func setupCell() {
        #if os(iOS)
        if #available(iOS 13.0, *) {
            backgroundColor = .secondarySystemGroupedBackground
        }
        else {
            backgroundColor = .darkGray
        }
        #endif

        contentView.addSubview(innerContentView)
        innerContentView.translatesAutoresizingMaskIntoConstraints = false

        leftPaddingConstraint = innerContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        rightPaddingConstraint = innerContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        bottomPaddingConstraint = innerContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        topPaddingConstraint = innerContentView.topAnchor.constraint(equalTo: contentView.topAnchor)

        NSLayoutConstraint.activate([
            leftPaddingConstraint, rightPaddingConstraint, bottomPaddingConstraint, topPaddingConstraint
        ])

        let contentStack = UIStackView()
        contentStack.axis = .horizontal
        contentStack.spacing = 20.0

        innerContentView.addSubview(contentStack)

        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: innerContentView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: innerContentView.trailingAnchor),
            contentStack.bottomAnchor.constraint(lessThanOrEqualTo: innerContentView.bottomAnchor),
            contentStack.topAnchor.constraint(greaterThanOrEqualTo: innerContentView.topAnchor),
            contentStack.centerYAnchor.constraint(equalTo: innerContentView.centerYAnchor)
        ])
        contentStack.addArrangedSubview(iconImageView)
        contentStack.addArrangedSubview(stackView)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)

        iconImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor, multiplier: 1).isActive = true
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)

        #if os(iOS)
        if #available(iOS 13.0, *) {
            separatorLine.backgroundColor = .tertiarySystemGroupedBackground
        }
        else {
            separatorLine.backgroundColor = .lightGray
        }
        contentView.addSubview(separatorLine)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        ])
        #endif
    }

    func setConfiguration(_ configuration: EasyItem.Configuration) {
        leftPaddingConstraint.constant = configuration.padding.left
        rightPaddingConstraint.constant = configuration.padding.right
        topPaddingConstraint.constant = configuration.padding.top
        bottomPaddingConstraint.constant = configuration.padding.bottom

        alpha = configuration.alpha
        backgroundColor = configuration.backgroundColor
        layer.cornerRadius = configuration.cornerRadius
        clipsToBounds = true

        self.configuration = configuration
    }

    func setAnimations(_ animations: EasyItem.Animations) {
        self.animations = animations
    }

    func setItem(_ item: EasyItem) {
        resetCell()

        hasAction = item.action != nil

        if let icon = item.icon {
            iconImageView.image = icon.image
            iconImageView.highlightedImage = icon.highlightedImage
            iconImageView.isHidden = false
        }

        switch item.content {
        case .text(let text, let numberOfLines):
            titleLabel.text = text
            titleLabel.numberOfLines = numberOfLines
            subtitleLabel.isHidden = true
        case .value(let title, let subtitle):
            titleLabel.text = title
            subtitleLabel.text = subtitle
            subtitleLabel.textAlignment = .right
        case .subtitle(let title, let subtitle):
            stackView.axis = .vertical
            titleLabel.text = title
            subtitleLabel.text = subtitle
            subtitleLabel.textAlignment = .left
            if subtitle == nil {
                subtitleLabel.isHidden = true
            }
        case .view:
            fatalError("Should not come here because .view(UIView) is handled by EasyCollectionHostCell")
        }
    }

    private func resetCell() {
        stackView.isHidden = false
        stackView.axis = .horizontal

        iconImageView.image = nil
        iconImageView.highlightedImage = nil
        iconImageView.isHidden = true

        titleLabel.text = nil
        titleLabel.numberOfLines = 1
        subtitleLabel.text = nil
        subtitleLabel.isHidden = false
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard hasAction else { return }
        self.animations.touchIn.forEach { $0.makeAnimation(self.viewForAnimation($0), using: configuration)() }
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard hasAction else { return }
        self.animations.touchOut.forEach { $0.makeAnimation(self.viewForAnimation($0), using: configuration)() }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard hasAction else { return }
        self.animations.touchOut.forEach { $0.makeAnimation(self.viewForAnimation($0), using: configuration)() }
    }

    public override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesBegan(presses, with: event)
        guard hasAction else { return }
        guard presses.contains(where: { $0.type == .select }) else { return }
        UIView.animate(withDuration: 0.12) {
            self.animations.pressIn.forEach { $0.makeAnimation(self.viewForAnimation($0), using: self.configuration)() }
        }
    }

    public override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesCancelled(presses, with: event)
        guard hasAction else { return }
        guard presses.contains(where: { $0.type == .select }) else { return }
        UIView.animate(withDuration: 0.12) {
            self.animations.pressOut.forEach { $0.makeAnimation(self.viewForAnimation($0), using: self.configuration)() }
        }
    }

    public override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesEnded(presses, with: event)
        guard hasAction else { return }
        guard presses.contains(where: { $0.type == .select }) else { return }
        UIView.animate(withDuration: 0.12) {
            self.animations.pressOut.forEach { $0.makeAnimation(self.viewForAnimation($0), using: self.configuration)() }
        }
    }

    public override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        if self == context.nextFocusedView {
            coordinator.addCoordinatedFocusingAnimations({ _ in
                self.animations.becomeFocused.forEach { $0.makeAnimation(self.viewForAnimation($0), using: self.configuration)() }
            }, completion: nil)
        }
        else if self == context.previouslyFocusedView {
            coordinator.addCoordinatedFocusingAnimations({ _ in
                self.animations.resignFocus.forEach { $0.makeAnimation(self.viewForAnimation($0), using: self.configuration)() }
            }, completion: nil)
        }
    }

    private func viewForAnimation(_ animation: EasyItem.Animation) -> UIView {
        switch animation {
        case .scale,
             .resetScale:
            return innerContentView
        case .background,
             .resetBackground,
             .alpha,
             .resetAlpha:
            return self
        }
    }
}
