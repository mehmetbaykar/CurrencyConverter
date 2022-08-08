//
//  BalanceCollectionViewCell.swift
//  CurrencyConverter
//
//  Created by Mehmet Baykar on 8/8/22.
//


import UIKit

class BalanceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.borderColor = UIColor.systemGray5.cgColor
        mainView.layer.borderWidth = 0.4
    }

    func config(titleString: String) {
        titleLabel.text = titleString
    }

}
