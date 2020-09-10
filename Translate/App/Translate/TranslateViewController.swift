//
//  TranslateViewController.swift
//  Translate
//
//  Created by Anton Pryakhin on 06.09.2020.
//

import Cartography
import UIKit

class TranslateViewController: UIViewController {

    // MARK: - ViewModel
    var viewModel: TranslateViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Translate"
        view.backgroundColor = .systemBackground

        setupTopButtons()
        setupTextViewFrom()
        setupTextViewTo()
        setupTapGestureForDismissKeyboard()
        setupSwipeGestureForClearTextViewFrom()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
//    private lazy var textViewToScroll = UIScrollView()
    private lazy var textViewTo = UITextView()
    private lazy var textViewToButton = UIButton()
    private lazy var activityIndicator = UIActivityIndicatorView()

    private func setupTopButtons() {
        translateFromButton.setTitle("Russian", for: .normal)
        translateFromButton.setTitleColor(Color.normal, for: .normal)
        translateFromButton.setTitleColor(Color.highlighted, for: .highlighted)
        translateFromButton.contentHorizontalAlignment = .center

        translateToButton.setTitle("English", for: .normal)
        translateToButton.setTitleColor(Color.normal, for: .normal)
        translateToButton.setTitleColor(Color.highlighted, for: .highlighted)
        translateToButton.contentHorizontalAlignment = .center

        let toggleLanguageButtonImage = UIImage(systemName: "arrow.right.arrow.left")
        toggleLanguageButton.setImage(toggleLanguageButtonImage?.withTintColor(Color.normal), for: .normal)
        toggleLanguageButton.setImage(toggleLanguageButtonImage?.withTintColor(Color.highlighted, renderingMode: .alwaysOriginal), for: .highlighted)

        topButtons.axis = .horizontal
        topButtons.spacing = 0.0
        topButtons.alignment = .center
        topButtons.distribution = .fillEqually
        topButtons.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topButtons)

        constrain(topButtons, view) { topButtons, view in
            topButtons.top == view.safeAreaLayoutGuide.top
            topButtons.left == view.left + 16.0
            topButtons.right == view.right - 16.0
            topButtons.height == 44.0
        }

        topButtonsSeparator.backgroundColor = .separator
        topButtonsSeparator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topButtonsSeparator)

        constrain(topButtonsSeparator, topButtons, view) { topButtonsSeparator, topButtons, view in
            topButtonsSeparator.top == topButtons.bottom
            topButtonsSeparator.left == view.left
            topButtonsSeparator.right == view.right
            topButtonsSeparator.height == 0.5
        }
    }

    private func setupTextViewFrom() {
        textViewFrom.isEditable = true
        textViewFrom.font = .systemFont(ofSize: 17.0)
        textViewFrom.textColor = .lightGray
        textViewFrom.text = "Enter text"
        textViewFrom.translatesAutoresizingMaskIntoConstraints = false
        textViewFrom.delegate = self
        view.addSubview(textViewFrom)

        let textViewFromButtonImage = UIImage(systemName: "xmark")
        textViewFromButton.setImage(textViewFromButtonImage?.withTintColor(Color.normal), for: .normal)
        textViewFromButton.setImage(textViewFromButtonImage?.withTintColor(Color.highlighted, renderingMode: .alwaysOriginal), for: .highlighted)
        textViewFromButton.isHidden = true
        textViewFromButton.addTarget(self, action: #selector(clearTextViewFrom), for: .touchUpInside)
        view.addSubview(textViewFromButton)

        constrain(textViewFrom, topButtons, textViewFromButton, view) { textViewFrom, topButtons, textViewFromButton, view in
            textViewFrom.top == topButtons.bottom + 8.0
            textViewFrom.left == view.left + 16.0
            textViewFrom.right == textViewFromButton.left - 16.0
            textViewFrom.height == 96.0

            textViewFromButton.top == topButtons.bottom + 16.0
            textViewFromButton.right == view.right - 16.0
        }

        textViewFromSeparator.backgroundColor = .separator
        textViewFromSeparator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textViewFromSeparator)

        constrain(textViewFromSeparator, textViewFrom, view) { textViewFromSeparator, textViewFrom, view in
            textViewFromSeparator.top == textViewFrom.bottom + 8.0
            textViewFromSeparator.left == view.left
            textViewFromSeparator.right == view.right
            textViewFromSeparator.height == 0.5
        }
    }

    private func setupTextViewTo() {
        textViewTo.isEditable = false
        textViewTo.font = .systemFont(ofSize: 17.0)
        textViewTo.textColor = .label
        textViewTo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textViewTo)

        let textViewToButtonImage = UIImage(systemName: "square.on.square")
        textViewToButton.setImage(textViewToButtonImage?.withTintColor(Color.normal), for: .normal)
        textViewToButton.setImage(textViewToButtonImage?.withTintColor(Color.highlighted, renderingMode: .alwaysOriginal), for: .highlighted)
        view.addSubview(textViewToButton)

        constrain(textViewTo, textViewFromSeparator, textViewToButton, view) { textViewTo, textViewFromSeparator, textViewToButton, view in
            textViewTo.top == textViewFromSeparator.bottom + 8.0
            textViewTo.left == view.left + 16.0
            textViewTo.right == textViewToButton.left - 16.0
            textViewTo.bottom == view.safeAreaLayoutGuide.bottomMargin - 8.0

            textViewToButton.top == textViewFromSeparator.bottom + 16.0
            textViewToButton.right == view.right - 16.0
        }
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
    
    private enum Color {

        static let normal = UIColor.systemBlue
        static let highlighted = normal.withAlphaComponent(0.3)
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
                textViewFrom.text = "Enter text"
            }
        default:
            break
        }
    }

    @objc
    private func clearTextViewFrom() {
        textViewFrom.text = nil
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
            textViewFrom.text = "Enter text"
        }

        textViewFromButton.isHidden = true
    }

    func textViewDidChange(_ textView: UITextView) {
        textViewFromButton.isHidden = textViewFrom.text.isEmpty

        textViewTo.text = textViewFrom.text
    }
}
