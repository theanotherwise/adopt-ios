//
//  Copyright © 2020 Damian Rzeszot. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet
    var titleLabel: UILabel!

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        contentView.layer.cornerRadius = 10

        layer.cornerRadius = 10
        layer.shadowColor = UIColor.secondaryLabel.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        layer.shadowOffset = .zero
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.shadowColor = UIColor.secondaryLabel.cgColor
    }

}
