//
//  ObraDeArteCell.swift
//  IOSUIkitFinal
//
//  Created by João Vitor De Freitas on 20/04/25.
//


import UIKit

class ObraDeArteCell: UICollectionViewCell {
    static let identifier = "ObraDeArteCell"

    let imagemView = UIImageView()
    let tituloLabel = UILabel()
    let artistaLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.masksToBounds = true   // keep corners clipped

           // --- Shadow on the cell itself ---
           layer.shadowColor   = UIColor.black.cgColor
           layer.shadowOpacity = 0.12              // subtle shadow
           layer.shadowRadius  = 4                 // blur
           layer.shadowOffset  = CGSize(width: 0, height: 2)
           layer.masksToBounds = false             // allow shadow to show
           // ----------------------------------
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        imagemView.contentMode = .scaleAspectFill
        imagemView.clipsToBounds = true

        tituloLabel.font = UIFont.boldSystemFont(ofSize: 14)
        tituloLabel.numberOfLines = 2

        artistaLabel.font = UIFont.systemFont(ofSize: 12)
        artistaLabel.textColor = .darkGray
        artistaLabel.numberOfLines = 1

        let stack = UIStackView(arrangedSubviews: [imagemView, tituloLabel, artistaLabel])
        stack.axis = .vertical
        stack.spacing = 8
        contentView.addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            imagemView.heightAnchor.constraint(equalTo: imagemView.widthAnchor)
        ])
    }

    func configure(with obra: ObraDeArte) {
        imagemView.image = UIImage(named: obra.imagemNome)
        tituloLabel.text = obra.titulo
        artistaLabel.text = obra.artista
    }
}
