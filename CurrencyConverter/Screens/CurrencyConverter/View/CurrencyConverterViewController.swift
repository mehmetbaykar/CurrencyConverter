//
//  CurrencyConverterViewController.swift
//  CurrencyConverter
//
//  Created by Mehmet Baykar on 8/8/22.
//

import UIKit
import RxSwift
import CurrencyConverterKit

final class CurrencyConverterViewController: BaseViewController<CurrencyConverterViewModel>,Instantiable {
    
    @IBOutlet weak var sellMenuButton: UIButton!
    @IBOutlet weak var receiveMenuButton: UIButton!
    @IBOutlet weak var sellTextField: UITextField!
    @IBOutlet weak var recieveLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!
    // MARK: - Properties
    var sellerButtonMenu = UIMenu()
    var receiverButtonMenu = UIMenu()
    var menuItems = [UIAction]()
    
    static var storyboardName: StringConvertible{
        return StoryboardName.main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        customizeNavigationBar()
        
    }
    
    func setupView() {
        setupSellMenuView()
        setupBuyMenuView()
        registerCollectionNib()
        setupButtons()
    }
    
    func setupButtons() {
        submitButton.layer.cornerRadius = submitButton.frame.height / 2
        sellMenuButton.setTitle(viewModel.sellCurrency.value, for: .normal)
        sellMenuButton.menu = sellerButtonMenu
        sellMenuButton.showsMenuAsPrimaryAction = true
        
        receiveMenuButton.setTitle(viewModel.buyCurrency.value, for: .normal)
        receiveMenuButton.menu = receiverButtonMenu
        receiveMenuButton.showsMenuAsPrimaryAction = true
    }
    
    func setupSellMenuView() {
        menuItems = []
        for item in SupportedCurrencyTypeAPIModel.allCases {
            let action = UIAction(title: item.code, image: nil, handler: { (_) in
                
                if item.code != self.receiveMenuButton.title(for: .normal) {
                    self.sellMenuButton.setTitle(item.code, for: .normal)
                    self.viewModel.sellCurrency.accept(item.code)
                    self.viewModel.onAmountTextFieldEditingChanged()
                }else{
                    self.showNotification(with: .error, text: "Please choose another type", position: .top, action: nil, actionName: nil)
                }
                
                
            })
            menuItems.append(action)
        }
        sellerButtonMenu = UIMenu(title: "Currency", options: .displayInline, children: menuItems)
    }
    
    func setupBuyMenuView() {
        menuItems = []
        for item in SupportedCurrencyTypeAPIModel.allCases {
            let action = UIAction(title: item.code, image: nil, handler: { (_) in
                
                if item.code != self.sellMenuButton.title(for: .normal) {
                    self.receiveMenuButton.setTitle(item.code, for: .normal)
                    self.viewModel.buyCurrency.accept(item.code)
                    self.viewModel.onAmountTextFieldEditingChanged()
                }else{
                    self.showNotification(with: .error, text: "Please choose another type", position: .top, action: nil, actionName: nil)
                }
                
            })
            menuItems.append(action)
        }
        receiverButtonMenu = UIMenu(title: "Currency", options: .displayInline, children: menuItems)
    }
    
    // MARK: Navigation Bar Customisation
    
    func customizeNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 18/255, green: 157/255, blue: 228/255, alpha: 1)
        
        let titleAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = titleAttribute
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func bindWithObserver() {
        super.bindWithObserver()
        setupViewBindings()
        setupApiBindings()
        setupDataBaseBindings()
        setupTapBindings()
       
    }
    
    
    func setupViewBindings() {
        setupTextField()
    }
    
    private func setupTextField() {
        sellTextField.rx
            .text
            .orEmpty
            .bind(to: viewModel.amount)
            .disposed(by: disposeBag)
        
        
        sellTextField.rx
            .text
            .orEmpty
            .map({$0.doubleValue})
            .map({$0 > 0.0})
            .bind(to:submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
    }
    
    private func registerCollectionNib() {
        collectionView.register(UINib(nibName: "BalanceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BalanceCollectionViewCell")
    }
    
    
    func setupTapBindings() {
        
        sellTextField.rx.controlEvent([.editingChanged])
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.viewModel.onAmountTextFieldEditingChanged()
            }.disposed(by: disposeBag)
        
        submitButton.rx.tap.asObservable().bind { [weak self] in
            self?.viewModel.onTapSubmit()
        }.disposed(by: self.disposeBag)
    }
    
    func setupDataBaseBindings(){
        viewModel.supportedCurrency.subscribe { [weak self] _ in
            self?.collectionView.reloadData()
        }.disposed(by: disposeBag)
    }
    func setupApiBindings() {
        
        viewModel.apiConvertSuccess.subscribe {[weak self] currencyAPIResponse in
            self?.recieveLabel.text =  "+" + String(currencyAPIResponse.amount)
        } onError: { error in
            self.showNotification(with: .error, text: error.localizedDescription, position: .center, action: nil, actionName: nil)
        }
        .disposed(by: disposeBag)
    }
}

extension CurrencyConverterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.supportedCurrency.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BalanceCollectionViewCell", for: indexPath) as! BalanceCollectionViewCell
        let titleText = "\(viewModel.supportedCurrency.value[indexPath.row].currencyAmount)" + " " + viewModel.supportedCurrency.value[indexPath.row].currencyName
        cell.config(titleString: titleText)
        return cell
    }
}

extension CurrencyConverterViewController:BaseView{}
