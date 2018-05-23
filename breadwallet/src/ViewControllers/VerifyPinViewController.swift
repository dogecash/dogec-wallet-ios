//
//  VerifyPinViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-01-17.
//  Copyright © 2017 breadwallet LLC. All rights reserved.
//

import UIKit

typealias VerifyPinCallback = (String, UIViewController) -> Bool

protocol ContentBoxPresenter {
    var contentBox : UIView { get }
    var blurView: UIVisualEffectView { get }
    var effect: UIBlurEffect { get }
}

class VerifyPinViewController : UIViewController, ContentBoxPresenter {

    init(bodyText: String, pinLength: Int, callback: @escaping VerifyPinCallback) {
        self.bodyText = bodyText
        self.callback = callback
        self.pinLength = pinLength
        self.pinView = PinView(style: .create, length: pinLength)
        super.init(nibName: nil, bundle: nil)
    }

    var didCancel: (()->Void)?
    let blurView = UIVisualEffectView()
    let effect = UIBlurEffect(style: .dark)
    let contentBox = UIView()
    private let callback: VerifyPinCallback
    private let pinPad = PinPadViewController(style: .white, keyboardType: .pinPad, maxDigits: 0)
    private let titleLabel = UILabel(font: .customBold(size: 22.0), color: .whiteTint)
    private let body = UILabel(font: .customBody(size: 19.0), color: .gradientStart)
    private let pinView: PinView
    private let toolbar = UIView(color: .darkGray)
    private let cancel = UIButton(type: .system)
    private let bodyText: String
    private let pinLength: Int

    override func viewDidLoad() {
        addSubviews()
        addConstraints()
        setupSubviews()
    }

    private func addSubviews() {
        view.addSubview(contentBox)
        view.addSubview(toolbar)
        toolbar.addSubview(cancel)

        contentBox.addSubview(titleLabel)
        contentBox.addSubview(body)
        contentBox.addSubview(pinView)
        addChildViewController(pinPad, layout: {
            pinPad.view.constrain([
                pinPad.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                pinPad.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                pinPad.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                pinPad.view.heightAnchor.constraint(equalToConstant: pinPad.height) ])
        })
    }

    private func addConstraints() {
        contentBox.constrain([
            contentBox.topAnchor.constraint(equalTo: view.topAnchor),
            contentBox.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            contentBox.widthAnchor.constraint(equalTo: view.widthAnchor) ])
        titleLabel.constrain([
            titleLabel.centerXAnchor.constraint(equalTo: contentBox.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentBox.topAnchor, constant: C.padding[4]) ])
        body.constrain([
            body.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            body.widthAnchor.constraint(equalToConstant: pinView.width),
            body.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: C.padding[8]) ])
        body.textAlignment = .center
        pinView.constrain([
            pinView.topAnchor.constraint(equalTo: body.bottomAnchor, constant: C.padding[8]),
            pinView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            /* pinView.centerYAnchor.constraint(equalTo: contentBox.centerYAnchor, constant: C.padding[4]), */
            pinView.widthAnchor.constraint(equalToConstant: pinView.width),
            pinView.heightAnchor.constraint(equalToConstant: pinView.itemSize) ])
        toolbar.constrain([
            toolbar.leadingAnchor.constraint(equalTo: pinPad.view.leadingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: pinPad.view.topAnchor),
            toolbar.trailingAnchor.constraint(equalTo: pinPad.view.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 44.0) ])
        cancel.constrain([
            cancel.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),
            cancel.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -C.padding[2]) ])
    }

    private func setupSubviews() {
        contentBox.backgroundColor = .darkGray

        titleLabel.text = S.VerifyPin.title
        body.text = bodyText
        body.numberOfLines = 0
        body.lineBreakMode = .byWordWrapping

        pinPad.ouputDidUpdate = { [weak self] output in
            guard let myself = self else { return }
            let attemptLength = output.utf8.count
            myself.pinView.fill(attemptLength)
            myself.pinPad.isAppendingDisabled = attemptLength < myself.pinLength ? false : true
            if attemptLength == myself.pinLength {
                if !myself.callback(output, myself) {
                    myself.authenticationFailed()
                } 
            }
        }
        cancel.tap = { [weak self] in
            self?.didCancel?()
            self?.dismiss(animated: true, completion: nil)
        }
        cancel.setTitle(S.Button.cancel, for: .normal)
        cancel.tintColor = .whiteTint
        view.backgroundColor = .clear
    }

    private func authenticationFailed() {
        pinPad.view.isUserInteractionEnabled = false
        pinView.shake { [weak self] in
            self?.pinPad.view.isUserInteractionEnabled = true
            self?.pinView.fill(0)
        }
        pinPad.clear()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
