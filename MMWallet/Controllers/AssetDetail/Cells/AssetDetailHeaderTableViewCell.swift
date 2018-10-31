//
//  AssetDetailHeaderTableViewCell.swift
//  MMWallet
//
//  Created by Dmitry Muravev on 24.07.2018.
//  Copyright © 2018 micromoney. All rights reserved.
//

import UIKit

class AssetDetailHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var currencyIconView: UIImageView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var cryptoBalanceLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var addressesButton: UIButton!
    
    var currencyChartView: CurrencyChartView?

    var assetModel: AssetDetailModel! {
        didSet {
            configureView()
        }
    }

    var assetSmallModel: AssetModel! {
        didSet {
            configureViewFromSmallModel()
        }
    }

    func configureViewFromSmallModel() {

        if let assetModel = assetSmallModel {

            if assetModel.isToken() {
                balanceLabel.text = assetModel.getCryptoBalanceString(isShort: true)
                cryptoBalanceLabel.text = ""
            } else {
                balanceLabel.text = "$ \(assetModel.rate!.USD.cleanValue)"
                cryptoBalanceLabel.text = assetModel.getCryptoBalanceString()
            }
            assetModel.setIconTo(imageView: currencyIconView, isSmall: true)
            currencyIconView.alpha = 1.0
            currencyLabel.text = assetModel.getCurrencyString().uppercased()
            gradientView.startColor = assetModel.getCurrencyColor()
            gradientView.endColor = assetModel.getCurrencyColor()

            switch assetModel.currency {
            case "BTC":
                currencyIconView.alpha = 0.5
            default:
                break
            }

            if assetModel.owner.count > 0 {
                addressesButton.isHidden = false
            } else {
                addressesButton.isHidden = true
            }
        }

        let downButtonImage = R.image.chevronIcon()
        downButton.setImage(downButtonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        downButton.tintColor = UIColor.white
        addCurrencyChart()
    }

    func configureView() {

        if let assetModel = assetModel {

            if let assetModelSmall = StorageManager.shared.getAsset(id: assetModel.id) {

                if assetModelSmall.isToken() {
                    balanceLabel.text = assetModelSmall.getCryptoBalanceString(isShort: true)
                    cryptoBalanceLabel.text = ""
                } else {
                    balanceLabel.text = "$ \(assetModel.rate!.USD.cleanValue)"
                    cryptoBalanceLabel.text = assetModelSmall.getCryptoBalanceString()
                }
                assetModelSmall.setIconTo(imageView: currencyIconView, isSmall: true)
                currencyIconView.alpha = 1.0
                currencyLabel.text = assetModelSmall.getCurrencyString().uppercased()
                gradientView.startColor = assetModelSmall.getCurrencyColor()
                gradientView.endColor = assetModelSmall.getCurrencyColor()

                switch assetModelSmall.currency {
                case "BTC":
                    currencyIconView.alpha = 0.5
                default:
                    break
                }

                if assetModel.owner.count > 0 {
                    addressesButton.isHidden = false
                } else {
                    addressesButton.isHidden = true
                }
            }
        }

        let downButtonImage = R.image.chevronIcon()
        downButton.setImage(downButtonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        downButton.tintColor = UIColor.white
        addCurrencyChart()
    }

    private func addCurrencyChart() {
        if currencyChartView == nil {
            currencyChartView = R.nib.currencyChartView.firstView(owner: nil)
            self.addSubview(currencyChartView!)
            currencyChartView!.snp.makeConstraints { (make) -> Void in
                make.bottom.equalTo(0)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(78)
            }
            currencyChartView!.isUserInteractionEnabled = false
        }

        if let assetModel = assetModel {
            currencyChartView?.applyData(currency: assetModel.currency)
        } else {
            if let assetSmallModel = assetSmallModel {
                currencyChartView?.applyData(currency: assetSmallModel.currency)
            }
        }

    }
    @IBAction func addressesListAction(_ sender: Any) {
        showTokenAddresses()
    }

    func showTokenAddresses() {
        let tokenOwnersView = R.nib.tokenOwnersView.firstView(owner: nil)
        UIApplication.shared.keyWindow?.addSubview(tokenOwnersView!)
        tokenOwnersView!.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
        }

        if assetModel != nil {
            tokenOwnersView!.configureView(assetId: assetModel!.id)
        }
    }
}
