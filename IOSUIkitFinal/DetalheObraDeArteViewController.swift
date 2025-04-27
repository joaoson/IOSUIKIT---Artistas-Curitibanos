//
//  DetalheObraDeArteViewController.swift
//  IOSUIkitFinal
//
//  Created by João Vitor De Freitas, Carlos Hobmeier, Amanda Queiroz e Theo Nicoleli on 26/04/25.
//

import UIKit

class DetalheObraDeArteViewController: UIViewController {
    
    var obra: ObraDeArte!
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imagemView = UIImageView()
    private let tituloLabel = UILabel()
    private let artistaLabel = UILabel()
    private let anoLabel = UILabel()
    private let estiloLabel = UILabel()
    private let descricaoLabel = UILabel()
    private let compartilharButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupUI()
        configureWithObra()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Respeitar safe areas em todos os lados
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        scrollView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
    }
    
    private func setupUI() {
        imagemView.contentMode = .scaleAspectFit
        imagemView.clipsToBounds = true
        
        tituloLabel.font = UIFont.boldSystemFont(ofSize: 24)
        tituloLabel.numberOfLines = 0
        
        artistaLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        artistaLabel.textColor = .darkGray
        
        anoLabel.font = UIFont.systemFont(ofSize: 16)
        anoLabel.textColor = .darkGray
        
        estiloLabel.font = UIFont.systemFont(ofSize: 16)
        estiloLabel.textColor = .darkGray
        
        descricaoLabel.font = UIFont.systemFont(ofSize: 16)
        descricaoLabel.numberOfLines = 0
        
        compartilharButton.setTitle("Compartilhar", for: .normal)
        compartilharButton.backgroundColor = .systemBlue
        compartilharButton.setTitleColor(.white, for: .normal)
        compartilharButton.layer.cornerRadius = 10
        compartilharButton.addTarget(self, action: #selector(compartilharTapped), for: .touchUpInside)
        
        [imagemView, tituloLabel, artistaLabel, anoLabel, estiloLabel, descricaoLabel, compartilharButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imagemView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imagemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imagemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imagemView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            tituloLabel.topAnchor.constraint(equalTo: imagemView.bottomAnchor, constant: 16),
            tituloLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tituloLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            artistaLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 8),
            artistaLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            artistaLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            anoLabel.topAnchor.constraint(equalTo: artistaLabel.bottomAnchor, constant: 8),
            anoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            anoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            estiloLabel.topAnchor.constraint(equalTo: anoLabel.bottomAnchor, constant: 8),
            estiloLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            estiloLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descricaoLabel.topAnchor.constraint(equalTo: estiloLabel.bottomAnchor, constant: 16),
            descricaoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descricaoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            compartilharButton.topAnchor.constraint(equalTo: descricaoLabel.bottomAnchor, constant: 24),
            compartilharButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            compartilharButton.widthAnchor.constraint(equalToConstant: 200),
            compartilharButton.heightAnchor.constraint(equalToConstant: 44),
            compartilharButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    private func configureWithObra() {
        guard obra != nil else { return }
        
        imagemView.image = UIImage(named: obra.imagemNome)
        tituloLabel.text = obra.titulo
        artistaLabel.text = obra.artista
        anoLabel.text = "Ano: \(obra.ano)"
        estiloLabel.text = "Estilo: \(obra.estilo)"
        descricaoLabel.text = obra.descricao
    }
    
    @objc private func compartilharTapped() {
        // Criar texto para compartilhamento
        let textoCompartilhamento = "Conheça '\(obra.titulo)' de \(obra.artista)! Venha descobrir mais artistas curitibanos em nosso aplicativo."
        
        let activityViewController = UIActivityViewController(
            activityItems: [textoCompartilhamento],
            applicationActivities: nil
        )
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = compartilharButton
            popoverController.sourceRect = compartilharButton.bounds
        }
        
        present(activityViewController, animated: true)
    }
}
