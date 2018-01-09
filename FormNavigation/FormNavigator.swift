//
//  FormNavigator.swift
//  FormNavigation
//
//  Created by Alex Antonyuk on 1/4/18.
//  Copyright © 2018 Alex Antonyuk. All rights reserved.
//

import UIKit

protocol NavigatableControl: class {
    var inputAccessoryView: UIView? { get set }
}

extension UITextField: NavigatableControl {}
extension UITextView: NavigatableControl {}

final class FormNavigator {

    private var controls: [UIResponder] = []
    private let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 200, height: 44.0))
    private var activeControl: UIResponder? = nil

    private lazy var prev = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(onPrev(_:)))
    private lazy var next = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(onNext(_:)))
    private lazy var done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onDone(_:)))

    init() {
        setupToolbar()
    }

    private func setupToolbar() {
        toolBar.items = [prev, next, UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), done]
    }

    /// Add control to the navigation stack
    ///
    /// - Parameter control: Control
    func add(control: UIResponder) {
        controls.append(control)

        NotificationCenter.default.addObserver(self, selector: #selector(onControlEvent(_:)), name: .UITextFieldTextDidBeginEditing, object: control)
        NotificationCenter.default.addObserver(self, selector: #selector(onControlEvent(_:)), name: .UITextViewTextDidBeginEditing, object: control)
    }

    /// Update toolbar width to match screen width
    ///
    /// - Parameter width: Toolbar width
    func updateToolbarWidth(_ width: CGFloat) {
        toolBar.bounds.size.width = width
    }


    /// Updates toolbar buttons enable state
    private func updateControls() {
        guard controls.count > 1 else {
            prev.isEnabled = false
            next.isEnabled = false
            return
        }

        guard let control = activeControl else { return }
        guard let index = controls.index(of: control) else { return }

        prev.isEnabled = index > 0
        next.isEnabled = index < controls.count - 1
    }

    @objc private func onPrev(_ sender: UIBarButtonItem) {
        guard let control = activeControl else { return }
        guard var index = controls.index(of: control) else { return }
        if index > 0 {
            index -= 1
        }
        activeControl = controls[index]
        activeControl?.becomeFirstResponder()
    }

    @objc private func onNext(_ sender: UIBarButtonItem) {
        guard let control = activeControl else { return }
        guard var index = controls.index(of: control) else { return }
        if index < controls.count - 1 {
            index += 1
        }
        activeControl = controls[index]
        activeControl?.becomeFirstResponder()
    }

    @objc private func onDone(_ sender: UIBarButtonItem) {
        activeControl?.resignFirstResponder()
        activeControl = nil
    }

    @objc private func onControlEvent(_ sender: Notification) {
        guard let control = sender.object as? UIResponder else { return }

        activeControl = control
        if let nc = activeControl as? NavigatableControl {
            nc.inputAccessoryView = toolBar
        }
        updateControls()
    }
}
