//
//  ViewController.swift
//  IOSUIkitFinal
//
//  Created by João Vitor De Freitas, Carlos Hobmeier, Amanda Queiroz e Theo Nicoleli on 20/04/25.
//


import UIKit

class ViewController2: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    var todasObras: [ObraDeArte] = [
        ObraDeArte(
            titulo: "Desenvolvimento histórico do Paraná",
            artista: "Poty Lazzarotto",
            ano: 1953,
            estilo: "Mural (azulejo)",
            imagemNome: "poty",
            descricao: "Painel de 3 × 30 m na Praça 19 de Dezembro; conta passagens marcantes da história paranaense."
        ),
        ObraDeArte(
            titulo: "Tigre Esmagando a Cobra",
            artista: "João Turin",
            ano: 1925,
            estilo: "Escultura em bronze",
            imagemNome: "tigre",
            descricao: "Obra-símbolo do Paranismo; peça em bronze hoje no Memorial Paranista."
        ),
        ObraDeArte(
            titulo: "Barca (Pescadores na Baía)",
            artista: "Alfredo Andersen",
            ano: 1894,
            estilo: "Óleo sobre tela",
            imagemNome: "barca",
            descricao: "Cena marítima que ilustra a fase inicial do ‘pai da pintura paranaense’."
        ),
        ObraDeArte(
            titulo: "Paisagem com Pinheiro",
            artista: "Miguel Bakun",
            ano: 1951,
            estilo: "Pós-impressionismo",
            imagemNome: "pinheiro",
            descricao: "Tela premiada no VIII Salão Paranaense; pinceladas densas e cores vibrantes."
        ),
        ObraDeArte(
            titulo: "Operários do Itaum",
            artista: "Juarez Machado",
            ano: 1963,
            estilo: "Figurativo / Art Déco",
            imagemNome: "trabalho",
            descricao: "Quadro vencedor do primeiro prêmio do artista, pintado enquanto estudava em Curitiba."
        ),
        ObraDeArte(
            titulo: "Silos do Jardim Botânico",
            artista: "Eduardo Kobra",
            ano: 2025,
            estilo: "Mural (street art)",
            imagemNome: "anaconda",
            descricao: "Painel de 5 000 m² nos silos do Moinho Anaconda; segunda maior obra do artista."
        ),
        ObraDeArte(
            titulo: "Sem título (Pêndulos de Cobre)",
            artista: "Eliane Prolik",
            ano: 1998,
            estilo: "Escultura/Instalação",
            imagemNome: "pendulo",
            descricao: "Peça neoconcreta que explora equilíbrio e tensão por meio de volumes ocos em cobre."
        ),
        ObraDeArte(
            titulo: "O Amor é a Resposta",
            artista: "Adriana Volpi",
            ano: 2020,
            estilo: "Acrílico sobre tela",
            imagemNome: "amor",
            descricao: "Obra da série de mandalas rendadas, feita sobre tela PET reciclada."
        ),
        ObraDeArte(
            titulo: "Museu Oscar Niemeyer (Olho)",
            artista: "Oscar Niemeyer",
            ano: 2002,
            estilo: "Arquitetura modernista",
            imagemNome: "olho",
            descricao: "Edifício-símbolo inaugurado em 2002; principal marco de arte e design de Curitiba."
        ),
        ObraDeArte(
            titulo: "Híbrido",
            artista: "Paulo Auma & Göla",
            ano: 2011,
            estilo: "Mural (street art)",
            imagemNome: "hibrido",
            descricao: "Intervenção colorida que mistura fauna e tecnologia, criada para a mostra ‘Híbrido’."
        )
    ]

    var obrasFiltradas: [ObraDeArte] = []
        
        var collectionView: UICollectionView!
        var searchBar: UISearchBar!
        
        // Layout control
        var itemsPerRowButton: UIButton!
        var itemsPerRowOptions = [1, 2, 3, 4]
        var selectedItemsPerRow = 2 // Default value
        
        private var isTransitioning = false
        private var collectionTopConstraint: NSLayoutConstraint!

        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupCustomNavigationBar()
            
            view.backgroundColor = .white
            
            navigationController?.delegate = self
            
            obrasFiltradas = todasObras
            
            setupSearchBarAndLayoutControl()
            setupCollectionView()
        }
        
        func setupCustomNavigationBar() {
            // Set the navigation bar color to dark blue
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = UIColor(red: 13/255, green: 36/255, blue: 53/255, alpha: 1.0) // #0d2435
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            
            title = ""
            
            let logoImageView = UIImageView(image: UIImage(named: "logo_artistas_curitibanos4"))
            logoImageView.contentMode = .scaleAspectFit
            
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                logoImageView.heightAnchor.constraint(equalToConstant: 66)
            ])
            
            navigationItem.titleView = logoImageView
        }
        
    func setupSearchBarAndLayoutControl() {
        // Container for search bar and layout control
        let topControlsContainer = UIView()
        topControlsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topControlsContainer)
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Buscar por título ou artista"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        topControlsContainer.addSubview(searchBar)
        
        itemsPerRowButton = createLayoutButton(for: selectedItemsPerRow)
        itemsPerRowButton.addTarget(self, action: #selector(cycleLayoutOption), for: .touchUpInside)
        itemsPerRowButton.translatesAutoresizingMaskIntoConstraints = false
        topControlsContainer.addSubview(itemsPerRowButton)
        
        NSLayoutConstraint.activate([
            topControlsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            topControlsContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            topControlsContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            // Search bar constraints
            searchBar.topAnchor.constraint(equalTo: topControlsContainer.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: topControlsContainer.leadingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: topControlsContainer.bottomAnchor),
            
            // Layout button constraints
            itemsPerRowButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            itemsPerRowButton.trailingAnchor.constraint(equalTo: topControlsContainer.trailingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: itemsPerRowButton.leadingAnchor, constant: -8)
        ])
        
        collectionTopConstraint = NSLayoutConstraint()
    }

    // Helper method to create a layout button with appropriate icon
    func createLayoutButton(for itemCount: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(getLayoutIcon(for: itemCount), for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        
        // Set fixed size constraints
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        return button
    }
        
        // Helper method to get the appropriate layout icon
        func getLayoutIcon(for itemCount: Int) -> UIImage? {
            let imageName: String
            switch itemCount {
            case 1:
                imageName = "rectangle"
            case 2:
                imageName = "rectangle.split.2x1"
            case 3:
                imageName = "rectangle.split.3x1"
            case 4:
                imageName = "rectangle.grid.2x2"
            default:
                imageName = "rectangle.split.2x1" // Default
            }
            
            // Try to get SF Symbol first
            if let sfSymbol = UIImage(systemName: imageName) {
                return sfSymbol.withRenderingMode(.alwaysTemplate)
            }
            
            // Fall back to custom images if needed
            return UIImage(named: "layout_\(itemCount)")
        }
        
        @objc func cycleLayoutOption() {
            // Find the current index in the options array
            guard let currentIndex = itemsPerRowOptions.firstIndex(of: selectedItemsPerRow) else { return }
            
            // Calculate the next index (cycling through the options)
            let nextIndex = (currentIndex + 1) % itemsPerRowOptions.count
            selectedItemsPerRow = itemsPerRowOptions[nextIndex]
            
            // Update the button image with animation
            UIView.transition(with: itemsPerRowButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.itemsPerRowButton.setImage(self.getLayoutIcon(for: self.selectedItemsPerRow), for: .normal)
            }, completion: nil)
            
            // Refresh collection view layout
            collectionView.collectionViewLayout.invalidateLayout()
        }
        
        // MARK: - UICollectionView
        
        func setupCollectionView() {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 16
            layout.minimumInteritemSpacing = 16
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .white
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(ObraDeArteCell.self, forCellWithReuseIdentifier: ObraDeArteCell.identifier)
            
            // Configuração do contentInset para o bottom para evitar que o conteúdo fique abaixo da home indicator
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            
            view.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            
            // Position below search bar
            collectionTopConstraint = collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8)
            
            NSLayoutConstraint.activate([
                collectionTopConstraint,
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
        }

        // MARK: - UICollectionViewDataSource
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return obrasFiltradas.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ObraDeArteCell.identifier, for: indexPath) as? ObraDeArteCell else {
                return UICollectionViewCell()
            }
            // Keep the cell with default styling (not dark)
            cell.configure(with: obrasFiltradas[indexPath.item])
            return cell
        }

        // MARK: - UICollectionViewDelegateFlowLayout
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            // Calculate cell width based on number of items per row
            let sectionInset = (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            let interitemSpacing = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 16
            
            let availableWidth = collectionView.frame.width - sectionInset.left - sectionInset.right
            let itemsPerRow = CGFloat(selectedItemsPerRow)
            let widthPerItem = (availableWidth - interitemSpacing * (itemsPerRow - 1)) / itemsPerRow
            
            return CGSize(width: widthPerItem, height: widthPerItem + 70)
        }
        
        // MARK: - UICollectionViewDelegate
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            // Evita múltiplos toques enquanto a animação está acontecendo
            guard !isTransitioning else { return }
            isTransitioning = true
            
            let obraSelecionada = obrasFiltradas[indexPath.item]
            let detalheVC = DetalheObraDeArteViewController()
            detalheVC.obra = obraSelecionada
            
            // Desabilitar interações na collection durante a animação
            collectionView.isUserInteractionEnabled = false
            
            // Apresentar a tela de detalhes
            navigationController?.pushViewController(detalheVC, animated: true)
            
            // Habilitar interações novamente após um período
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.collectionView.isUserInteractionEnabled = true
                self.isTransitioning = false
            }
        }
        
        // MARK: - UISearchBarDelegate
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {
                // Se o texto estiver vazio, mostrar todas as obras
                obrasFiltradas = todasObras
            } else {
                // Filtrar as obras que contêm o texto no título ou no nome do artista (case insensitive)
                obrasFiltradas = todasObras.filter { obra in
                    return obra.titulo.lowercased().contains(searchText.lowercased()) ||
                           obra.artista.lowercased().contains(searchText.lowercased())
                }
            }
            
            collectionView.reloadData()
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
        

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            obrasFiltradas = todasObras
            collectionView.reloadData()
            searchBar.resignFirstResponder()
        }
        
        override func viewWillTransition(to size: CGSize,
                                         with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            
            coordinator.animate(alongsideTransition: nil) { _ in
                // Depois que a rotação conclui, invalida o layout
                self.collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }

    // MARK: - Custom Navigation Controller Delegate
    extension ViewController2: UINavigationControllerDelegate {
        
        func navigationController(_ navigationController: UINavigationController,
                                 animationControllerFor operation: UINavigationController.Operation,
                                 from fromVC: UIViewController,
                                 to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            if operation == .push {
                return CortinaPushAnimator(isPushing: true)
            } else if operation == .pop {
                return CortinaPushAnimator(isPushing: false)
            }
            return nil
        }
    }
