//
//  SplashViewController.swift
//  IOSUIkitFinal
//
//  Created by João Vitor De Freitas, Carlos Hobmeier, Amanda Queiroz e Theo Nicoleli on 23/04/25.
//

import UIKit

final class SplashViewController: UIViewController {

    // MARK: - Public callback
    var onFinish: (() -> Void)?

    // MARK: - Private UI
    private let logoView: UIImageView = {
        let image = UIImage(named: "capy") 
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
z        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.animateAndFinish()
        }
    }

    // MARK: - Setup
    private func configureView() {
        view.backgroundColor = UIColor(red: 0.90, green: 0.96, blue: 1.0, alpha: 1.0) // azul-claro
        view.addSubview(logoView)

        NSLayoutConstraint.activate([
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor)
        ])
    }

    // MARK: - Animations
    private func animateAndFinish() {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseOut,
            animations: { [weak self] in
                guard let self = self else { return }
                self.logoView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.logoView.alpha = 0
            }, completion: { [weak self] _ in
                self?.onFinish?()
            })
    }
}
