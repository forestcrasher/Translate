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
        setupBindings()
    }

    // MARK: - Private
    private lazy var sourceLanguageButton = UIButton()
    private lazy var targetLanguageButton = UIButton()
    private lazy var toggleLanguageButton = UIButton()
    private lazy var topButtons = UIStackView(arrangedSubviews: [sourceLanguageButton, toggleLanguageButton, targetLanguageButton])
    private lazy var topButtonsSeparator = UIView()
    private lazy var sourceTextView = UITextView()
    private lazy var clearButton = UIButton()
    private lazy var sourceSeparator = UIView()
    private lazy var targetTextView = UITextView()
    private lazy var copyButton = UIButton()
    private lazy var activityIndicatorView = UIActivityIndicatorView()
    
    private var disposeBag = DisposeBag()
    
    private func setupUI() {

        setupView()
        setupTopButtons()
        setupSourceText()
        setupTargetText()
        setupActivityIndicator()
        setupGestures()
        setupNotificationCenter()
    }
    
    private func setupView() {
        
        title = Constants.title
        view.backgroundColor = .systemBackground
    }
    
    private func setupTopButtons() {
        
        sourceLanguageButton.setTitle(Constants.sourceLanguageTitle, for: .normal)
        sourceLanguageButton.setTitleColor(Constants.normalColor, for: .normal)
        sourceLanguageButton.setTitleColor(Constants.highlightedColor, for: .highlighted)
        sourceLanguageButton.contentHorizontalAlignment = .center

        targetLanguageButton.setTitle(Constants.targetLanguageTitle, for: .normal)
        targetLanguageButton.setTitleColor(Constants.normalColor, for: .normal)
        targetLanguageButton.setTitleColor(Constants.highlightedColor, for: .highlighted)
        targetLanguageButton.contentHorizontalAlignment = .center

        let toggleLanguageIcon = UIImage(systemName: Constants.toggleButtonIcon)
        toggleLanguageButton.setImage(toggleLanguageIcon?.withTintColor(Constants.normalColor), for: .normal)
        toggleLanguageButton.setImage(toggleLanguageIcon?.withTintColor(Constants.highlightedColor, renderingMode: .alwaysOriginal), for: .highlighted)

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

    private func setupSourceText() {
        
        sourceTextView.isEditable = true
        sourceTextView.font = .systemFont(ofSize: Constants.fontSize)
        sourceTextView.textColor = .lightGray
        sourceTextView.text = Constants.sourceTextPlaceholder
        sourceTextView.translatesAutoresizingMaskIntoConstraints = false
        sourceTextView.delegate = self
        view.addSubview(sourceTextView)

        let clearButtonIcon = UIImage(systemName: Constants.clearButtonIcon)
        clearButton.setImage(clearButtonIcon?.withTintColor(Constants.normalColor), for: .normal)
        clearButton.setImage(clearButtonIcon?.withTintColor(Constants.highlightedColor, renderingMode: .alwaysOriginal), for: .highlighted)
        clearButton.isHidden = true
        clearButton.addTarget(self, action: #selector(clearTextViewFrom), for: .touchUpInside)
        view.addSubview(clearButton)

        constrain(sourceTextView, topButtons, clearButton, view) { sourceTextView, topButtons, clearButton, view in
            sourceTextView.top == topButtons.bottom + Constants.verticalPadding
            sourceTextView.left == view.left + Constants.horizontalPadding
            sourceTextView.right == clearButton.left - Constants.horizontalPadding
            sourceTextView.height == Constants.textViewHeight
            clearButton.top == topButtons.bottom + Constants.horizontalPadding
            clearButton.right == view.right - Constants.horizontalPadding
        }

        sourceSeparator.backgroundColor = .separator
        sourceSeparator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sourceSeparator)

        constrain(sourceSeparator, sourceTextView, view) { sourceSeparator, sourceTextView, view in
            sourceSeparator.top == sourceTextView.bottom + Constants.verticalPadding
            sourceSeparator.left == view.left
            sourceSeparator.right == view.right
            sourceSeparator.height == Constants.separatorHeight
        }
    }

    private func setupTargetText() {
        
        targetTextView.isEditable = false
        targetTextView.font = .systemFont(ofSize: Constants.fontSize)
        targetTextView.textColor = .label
        targetTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(targetTextView)

        let copyButtonIcon = UIImage(systemName: Constants.copyButtonIcon)
        copyButton.setImage(copyButtonIcon?.withTintColor(Constants.normalColor), for: .normal)
        copyButton.setImage(copyButtonIcon?.withTintColor(Constants.highlightedColor, renderingMode: .alwaysOriginal), for: .highlighted)
        copyButton.isHidden = true
        copyButton.addTarget(self, action: #selector(copyTextViewTo), for: .touchUpInside)
        view.addSubview(copyButton)

        constrain(targetTextView, sourceSeparator, copyButton, view) { targetTextView, sourceSeparator, copyButton, view in
            targetTextView.top == sourceSeparator.bottom + Constants.verticalPadding
            targetTextView.left == view.left + Constants.horizontalPadding
            targetTextView.right == copyButton.left - Constants.horizontalPadding
            targetTextView.bottom == view.safeAreaLayoutGuide.bottom - Constants.verticalPadding
            copyButton.top == sourceSeparator.bottom + Constants.horizontalPadding
            copyButton.right == view.right - Constants.horizontalPadding
        }
        
        targetTextView.rx.text
            .bind(onNext: { [unowned self] in
                self.copyButton.isHidden = ($0?.isEmpty ?? true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupActivityIndicator() {
        
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
    }
    
    private func setupGestures() {
        
        setupTapGestureForDismissKeyboard()
        setupSwipeGestureForClearSourceText()
    }

    private func setupTapGestureForDismissKeyboard() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(TranslateViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    private func setupSwipeGestureForClearSourceText() {
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(TranslateViewController.clearSourceTextByGesture))
        swipe.direction = [.left]
        sourceTextView.addGestureRecognizer(swipe)
    }
    
    private func setupNotificationCenter() {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func setupBindings() {
        
        setupViewModel()
        setupSourceLanguageBinding()
        setupTargetLanguageBinding()
        setupToggleButtonBinding()
        setupTranslationBinding()
        setupActivityIndicatorBinding()
    }
    
    private func setupViewModel() {
        
        viewModel.setup(with: TranslateViewModel.Input(
            showSelectionSourceLanguage: sourceLanguageButton.rx.tap.asSignal(),
            showSelectionTargetLanguage: targetLanguageButton.rx.tap.asSignal(),
            toggleLanguage: toggleLanguageButton.rx.tap.asSignal(),
            sourceText: sourceTextView.rx.text.orEmpty.asDriver()
        ))
    }
    
    private func setupSourceLanguageBinding() {
        
        viewModel?.currentSourceLanguage
            .bind(onNext: { [unowned self] language in
                self.sourceLanguageButton.setTitle(language?.name?.capitalized, for: .normal)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTargetLanguageBinding() {
        
        viewModel?.currentTargetLanguage
            .bind(onNext: { [unowned self] language in
                self.targetLanguageButton.setTitle(language?.name?.capitalized, for: .normal)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupToggleButtonBinding() {
        
        viewModel?.currentSourceLanguage
            .bind(onNext: { [unowned self] language in
                self.toggleLanguageButton.isEnabled = !(language?.code.isEmpty ?? true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTranslationBinding() {
        
        viewModel.translations
            .bind(onNext: { [unowned self] in
                self.targetTextView.text = $0.first?.text
            })
            .disposed(by: disposeBag)
    }
    
    private func setupActivityIndicatorBinding() {
        
        viewModel.isLoading
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    @objc
    private func clearTextViewFrom() {
        
        sourceTextView.text = nil
    }

    @objc
    private func copyTextViewTo() {
        
        UIPasteboard.general.string = targetTextView.text
    }

    @objc
    private func clearSourceTextByGesture(_ sender: UISwipeGestureRecognizer) {
        
        switch sender.state {
        case .ended:
            if sourceTextView.textColor != UIColor.lightGray {
                sourceTextView.text = nil
                clearButton.isHidden = true
            }

            if !sourceTextView.isFirstResponder {
                sourceTextView.textColor = .lightGray
                sourceTextView.text = Constants.sourceTextPlaceholder
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
            targetTextView.contentInset = .zero
        } else {
            targetTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        targetTextView.scrollIndicatorInsets = targetTextView.contentInset

        let selectedRange = targetTextView.selectedRange
        targetTextView.scrollRangeToVisible(selectedRange)
    }
}

extension TranslateViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if sourceTextView.textColor == UIColor.lightGray && sourceTextView.isFirstResponder {
            sourceTextView.text = nil
            sourceTextView.textColor = .label
        }

        clearButton.isHidden = sourceTextView.text.isEmpty
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        
        if sourceTextView.text.isEmpty {
            sourceTextView.textColor = .lightGray
            sourceTextView.text = Constants.sourceTextPlaceholder
        }

        clearButton.isHidden = true
    }

    func textViewDidChange(_ textView: UITextView) {
        
        clearButton.isHidden = sourceTextView.text.isEmpty
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
    static let sourceLanguageTitle = "Russian"
    static let targetLanguageTitle = "English"
    static let sourceTextPlaceholder = "Enter text⁣"
}
