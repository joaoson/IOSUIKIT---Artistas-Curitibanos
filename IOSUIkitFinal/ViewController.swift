//
//  ViewController.swift
//  IOSUIkitFinal
//
//  Created by João Vitor De Freitas on 20/04/25.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // Todas as obras disponíveis
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
    var itemsPerRowContainerView: UIView!
    
    var itemsPerRowPicker: UIPickerView!
    var itemsPerRowButton: UIButton!
    var itemsPerRowOptions = [1, 2, 3, 4]
    var selectedItemsPerRow = 2
    
    private var isTransitioning = false
    private var collectionTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Artistas Curitibanos"
        view.backgroundColor = .white
        
        navigationController?.delegate = self
        
        obrasFiltradas = todasObras
        
        setupSearchBar()
        setupCollectionView()
        setupItemsPerRowControl()
    }
    
    // Configuração da barra de pesquisa
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Buscar por título ou artista"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Adiciona a searchBar na view
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8), // Adicionado padding superior
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8), // Padding lateral
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8) // Padding lateral
        ])
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
        
        collectionTopConstraint = collectionView.topAnchor
                .constraint(equalTo: searchBar.bottomAnchor, constant: 8)

        // Initially position below search bar
        NSLayoutConstraint.activate([
            collectionTopConstraint,
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func setupItemsPerRowControl() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4          // espaço entre botão e picker
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        itemsPerRowButton = UIButton(type: .system)
        itemsPerRowButton.setTitle("Items por linha: \(selectedItemsPerRow)", for: .normal)
        itemsPerRowButton.backgroundColor = .systemGray6
        itemsPerRowButton.layer.cornerRadius = 8
        itemsPerRowButton.addTarget(self,
                                    action: #selector(toggleItemsPerRowPicker),
                                    for: .touchUpInside)
        
        itemsPerRowPicker = UIPickerView()
        itemsPerRowPicker.delegate = self
        itemsPerRowPicker.dataSource = self
        itemsPerRowPicker.isHidden = true          // começa fechado
        itemsPerRowPicker.selectRow(
            itemsPerRowOptions.firstIndex(of: selectedItemsPerRow) ?? 1,
            inComponent: 0,
            animated: false
        )
        
        stack.addArrangedSubview(itemsPerRowButton)
        stack.addArrangedSubview(itemsPerRowPicker)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        collectionView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 8).isActive = true
        
        collectionTopConstraint.isActive = false      // remove a constraint anterior
            collectionTopConstraint = collectionView.topAnchor
                .constraint(equalTo: stack.bottomAnchor, constant: 8)
            collectionTopConstraint.isActive = true
    }
    
    @objc func toggleItemsPerRowPicker() {
        itemsPerRowPicker.isHidden.toggle()
        collectionView.collectionViewLayout.invalidateLayout()
        
        // Anima o colapso/expansão (opcional)
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return obrasFiltradas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ObraDeArteCell.identifier, for: indexPath) as? ObraDeArteCell else {
            return UICollectionViewCell()
        }
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
        
        // Height is proportional to width plus space for text
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
        
        // Recarregar a collection view para mostrar os resultados filtrados
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Esconder o teclado quando o botão de busca for clicado
        searchBar.resignFirstResponder()
    }
    
    // Para limpar a pesquisa quando o botão 'cancelar' for clicado (se estiver visível)
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        obrasFiltradas = todasObras
        collectionView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemsPerRowOptions.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(itemsPerRowOptions[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItemsPerRow = itemsPerRowOptions[row]
        itemsPerRowButton.setTitle("Items per row: \(selectedItemsPerRow)", for: .normal)
        self.collectionView.collectionViewLayout.invalidateLayout()
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
extension ViewController: UINavigationControllerDelegate {
    
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

