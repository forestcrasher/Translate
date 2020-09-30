//
//  TranslateViewController.swift
//  Translate
//
//  Created by Anton Pryakhin on 06.09.2020.
//

import Cartography
import UIKit
import RxSwift
import RxCocoa

class TranslateViewController: UIViewController {

    // MARK: - ViewModel
    var viewModel: TranslateViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupGestures()
        setupBindings()
        setupNotificationCenter()
    }

    // MARK: - Private
    private lazy var translateFromButton = UIButton()
    private lazy var translateToButton = UIButton()
    private lazy var toggleLanguageButton = UIButton()
    private lazy var topButtons = UIStackView(arrangedSubviews: [translateFromButton, toggleLanguageButton, translateToButton])
    private lazy var topButtonsSeparator = UIView()
    private lazy var textViewFrom = UITextView()
    private lazy var textViewFromButton = UIButton()
    private lazy var textViewFromSeparator = UIView()
    private lazy var textViewTo = UITextView()
    private lazy var textViewToButton = UIButton()
    private lazy var activityIndicator = UIActivityIndicatorView()
    
    private var disposeBag = DisposeBag()
    
    private func setupUI() {
        title = Constants.title
        view.backgroundColor = .systemBackground
        
        setupTopButtons()
        setupTextViewFrom()
        setupTextViewTo()
    }

    private func setupTopButtons() {
        translateFromButton.setTitle(Constants.translateFromButtonTitle, for: .normal)
        translateFromButton.setTitleColor(Constants.normalColor, for: .normal)
        translateFromButton.setTitleColor(Constants.highlightedColor, for: .highlighted)
        translateFromButton.contentHorizontalAlignment = .center
        translateFromButton.addTarget(self, action: #selector(selectLanguageFrom), for: .touchUpInside)

        translateToButton.setTitle(Constants.translateToButtonTitle, for: .normal)
        translateToButton.setTitleColor(Constants.normalColor, for: .normal)
        translateToButton.setTitleColor(Constants.highlightedColor, for: .highlighted)
        translateToButton.contentHorizontalAlignment = .center
        translateToButton.addTarget(self, action: #selector(selectLanguageTo), for: .touchUpInside)

        let toggleLanguageButtonImage = UIImage(systemName: Constants.toggleButtonIcon)
        toggleLanguageButton.setImage(toggleLanguageButtonImage?.withTintColor(Constants.normalColor), for: .normal)
        toggleLanguageButton.setImage(toggleLanguageButtonImage?.withTintColor(Constants.highlightedColor, renderingMode: .alwaysOriginal),
                                      for: .highlighted)
        toggleLanguageButton.addTarget(self, action: #selector(toggleLanguage), for: .touchUpInside)

        topButtons.axis = .horizontal
        topButtons.spacing = 0.0
        topButtons.alignment = .center
        topButtons.distribution = .fillEqually
        topButtons.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topButtons)

        constrain(topButtons, view) { topButtons, view in
            topButtons.top == view.safeAreaLayoutGuide.top
            topButtons.left == view.left + Constants.horizontalPadding
            topButtons.right == view.right - Constants.horizontalPadding
            topButtons.height == Constants.buttonHeight
        }

        topButtonsSeparator.backgroundColor = .separator
        topButtonsSeparator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topButtonsSeparator)

        constrain(topButtonsSeparator, topButtons, view) { topButtonsSeparator, topButtons, view in
            topButtonsSeparator.top == topButtons.bottom
            topButtonsSeparator.left == view.left
            topButtonsSeparator.right == view.right
            topButtonsSeparator.height == Constants.separatorHeight
        }
    }

    private func setupTextViewFrom() {
        textViewFrom.isEditable = true
        textViewFrom.font = .systemFont(ofSize: Constants.fontSize)
        textViewFrom.textColor = .lightGray
        textViewFrom.text = Constants.textViewFromPlaceholder
        textViewFrom.translatesAutoresizingMaskIntoConstraints = false
        textViewFrom.delegate = self
        view.addSubview(textViewFrom)

        let textViewFromButtonImage = UIImage(systemName: Constants.clearButtonIcon)
        textViewFromButton.setImage(textViewFromButtonImage?.withTintColor(Constants.normalColor), for: .normal)
        textViewFromButton.setImage(textViewFromButtonImage?.withTintColor(Constants.highlightedColor, renderingMode: .alwaysOriginal),
                                    for: .highlighted)
        textViewFromButton.isHidden = true
        textViewFromButton.addTarget(self, action: #selector(clearTextViewFrom), for: .touchUpInside)
        view.addSubview(textViewFromButton)

        constrain(textViewFrom, topButtons, textViewFromButton, view) { textViewFrom, topButtons, textViewFromButton, view in
            textViewFrom.top == topButtons.bottom + Constants.verticalPadding
            textViewFrom.left == view.left + Constants.horizontalPadding
            textViewFrom.right == textViewFromButton.left - Constants.horizontalPadding
            textViewFrom.height == Constants.textViewHeight

            textViewFromButton.top == topButtons.bottom + Constants.horizontalPadding
            textViewFromButton.right == view.right - Constants.horizontalPadding
        }

        textViewFromSeparator.backgroundColor = .separator
        textViewFromSeparator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textViewFromSeparator)

        constrain(textViewFromSeparator, textViewFrom, view) { textViewFromSeparator, textViewFrom, view in
            textViewFromSeparator.top == textViewFrom.bottom + Constants.verticalPadding
            textViewFromSeparator.left == view.left
            textViewFromSeparator.right == view.right
            textViewFromSeparator.height == Constants.separatorHeight
        }
    }

    private func setupTextViewTo() {
        textViewTo.isEditable = false
        textViewTo.font = .systemFont(ofSize: Constants.fontSize)
        textViewTo.textColor = .label
        textViewTo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textViewTo)

        let textViewToButtonImage = UIImage(systemName: Constants.copyButtonIcon)
        textViewToButton.setImage(textViewToButtonImage?.withTintColor(Constants.normalColor), for: .normal)
        textViewToButton.setImage(textViewToButtonImage?.withTintColor(Constants.highlightedColor, renderingMode: .alwaysOriginal), for: .highlighted)
        textViewToButton.isHidden = true
        textViewToButton.addTarget(self, action: #selector(copyTextViewTo), for: .touchUpInside)
        view.addSubview(textViewToButton)

        constrain(textViewTo, textViewFromSeparator, textViewToButton, view) { textViewTo, textViewFromSeparator, textViewToButton, view in
            textViewTo.top == textViewFromSeparator.bottom + Constants.verticalPadding
            textViewTo.left == view.left + Constants.horizontalPadding
            textViewTo.right == textViewToButton.left - Constants.horizontalPadding
            textViewTo.bottom == view.safeAreaLayoutGuide.bottom - Constants.verticalPadding

            textViewToButton.top == textViewFromSeparator.bottom + Constants.horizontalPadding
            textViewToButton.right == view.right - Constants.horizontalPadding
        }
    }
    
    private func setupGestures() {
        setupTapGestureForDismissKeyboard()
        setupSwipeGestureForClearTextViewFrom()
    }

    private func setupTapGestureForDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(TranslateViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    private func setupSwipeGestureForClearTextViewFrom() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(TranslateViewController.clearTextViewFromByGesture))
        swipe.direction = [.left]
        textViewFrom.addGestureRecognizer(swipe)
    }
    
    private func setupBindings() {
        setupLanguageFrom()
        setupLanguageTo()
        setupToggleButton()
    }
    
    private func setupLanguageFrom() {
        viewModel?.currentLanguageFrom
            .subscribe(onNext: { [unowned self] language in
                self.translateFromButton.setTitle(language?.name?.capitalized, for: .normal)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupLanguageTo() {
        viewModel?.currentLanguageTo
            .subscribe(onNext: { [unowned self] language in
                self.translateToButton.setTitle(language?.name?.capitalized, for: .normal)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupToggleButton() {
        viewModel?.currentLanguageFrom
            .subscribe(onNext: { [unowned self] language in
                self.toggleLanguageButton.isEnabled = !(language?.code.isEmpty ?? true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustForKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustForKeyboard),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    @objc
    private func clearTextViewFrom() {
        textViewFrom.text = nil
    }

    @objc
    private func copyTextViewTo() {
        UIPasteboard.general.string = textViewTo.text
    }
    
    @objc
    private func selectLanguageFrom() {
        viewModel?.showSelectionLanguageFrom()
    }
    
    @objc
    private func selectLanguageTo() {
        viewModel?.showSelectionLanguageTo()
    }
    
    @objc
    private func toggleLanguage() {
        viewModel?.toggleLanguage()
    }

    @objc
    private func clearTextViewFromByGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.state {
        case .ended:
            if textViewFrom.textColor != UIColor.lightGray {
                textViewFrom.text = nil
                textViewFromButton.isHidden = true
            }

            if !textViewFrom.isFirstResponder {
                textViewFrom.textColor = .lightGray
                textViewFrom.text = Constants.textViewFromPlaceholder
            }
        default:
            break
        }
    }

    @objc
    private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            view.endEditing(true)
        default:
            break
        }
    }

    @objc
    private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            textViewTo.contentInset = .zero
        } else {
            textViewTo.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        textViewTo.scrollIndicatorInsets = textViewTo.contentInset

        let selectedRange = textViewTo.selectedRange
        textViewTo.scrollRangeToVisible(selectedRange)
    }
}

extension TranslateViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textViewFrom.textColor == UIColor.lightGray && textViewFrom.isFirstResponder {
            textViewFrom.text = nil
            textViewFrom.textColor = .label
        }

        textViewFromButton.isHidden = textViewFrom.text.isEmpty
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textViewFrom.text.isEmpty {
            textViewFrom.textColor = .lightGray
            textViewFrom.text = Constants.textViewFromPlaceholder
        }

        textViewFromButton.isHidden = true
    }

    func textViewDidChange(_ textView: UITextView) {
        textViewFromButton.isHidden = textViewFrom.text.isEmpty

        textViewTo.text = textViewFrom.text
        textViewToButton.isHidden = textViewTo.text == nil
    }
}

private enum Constants {

    static let normalColor = UIColor.systemBlue
    static let highlightedColor = normalColor.withAlphaComponent(0.3)

    static let horizontalPadding: CGFloat = 16.0
    static let verticalPadding: CGFloat = 8.0
    static let separatorHeight: CGFloat = 0.5
    static let buttonHeight: CGFloat = 44.0
    static let textViewHeight: CGFloat = 96.0
    static let fontSize: CGFloat = 17.0

    static let toggleButtonIcon = "arrow.right.arrow.left"
    static let clearButtonIcon = "xmark"
    static let copyButtonIcon = "square.on.square"

    static let title = "Translate"
    static let translateFromButtonTitle = "Russian"
    static let translateToButtonTitle = "English"
    static let textViewFromPlaceholder = "Enter text"
}
