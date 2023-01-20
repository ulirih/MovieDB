//
//  ViewController.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 21.12.2022.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<MainViewSections, AnyHashable>!
    
    var viewModel: MainViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MovieDB"
        view.backgroundColor = .secondarySystemBackground
        
        setupView()
        setupBind()
        setupConstraints()
        
        viewModel.fetchNowPlaying()
        viewModel.fetchTrendings()
    }
    
    private func setupView() {
        setupCollectionView()
        view.addSubview(collectionView)
        view.addSubview(loaderView)
    }
    
    private func setupBind() {
        viewModel.nowPlaying
            .subscribe(onNext: { [weak self] playingNow in
                guard let self = self else { return }
                var snapshot = self.dataSource.snapshot()
                snapshot.appendSections([.playingNow])
                snapshot.appendItems(playingNow, toSection: .playingNow)
                self.dataSource.apply(snapshot)
            })
            .disposed(by: disposeBag)
        
        viewModel.trendings
            .subscribe(onNext: { [weak self] trendings in
                guard let self = self else { return }
                
                var snapshot = self.dataSource.snapshot()
                if !snapshot.sectionIdentifiers.contains(.trendings) {
                    // add section only on first load
                    snapshot.appendSections([.trendings])
                }
                snapshot.appendItems(trendings, toSection: .trendings)
                self.dataSource.apply(snapshot)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .bind(to: loaderView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let object = self?.dataSource.itemIdentifier(for: indexPath)
                switch indexPath.section {
                case MainViewSections.playingNow.rawValue:
                    self?.viewModel.didTapMovie(movieId: (object as! PlayNowModel).id)
                case MainViewSections.trendings.rawValue:
                    self?.viewModel.didTapMovie(movieId: (object as! TrendingModel).id)
                default: return
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    private let loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.style = .large
        
        return loader
    }()
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TrendMovieViewCell.self, forCellWithReuseIdentifier: TrendMovieViewCell.reusableId)
        collectionView.register(NowPlayingViewCell.self, forCellWithReuseIdentifier: NowPlayingViewCell.reusableId)
        collectionView.register(HeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderViewCell.reusableId)
        collectionView.register(LoadMoreViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadMoreViewCell.reusableId)
        createDataSource()
    }
}

// MARK: CompositionalLayout
extension MainViewController {
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MainViewSections, AnyHashable>(collectionView: collectionView, cellProvider: { (collectionView, path, object) -> UICollectionViewCell? in
            switch path.section {
            case MainViewSections.trendings.rawValue:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendMovieViewCell.reusableId, for: path) as! TrendMovieViewCell
                cell.configure(model: object as! TrendingModel)
                return cell
            case MainViewSections.playingNow.rawValue:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingViewCell.reusableId, for: path) as! NowPlayingViewCell
                cell.configure(with: object as! PlayNowModel)
                return cell
            default: return nil
            }
        })
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in

            // load more footer
            if kind == UICollectionView.elementKindSectionFooter {
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadMoreViewCell.reusableId, for: indexPath) as! LoadMoreViewCell
                if let self = self, self.viewModel.isEnableLoadMore {
                    cell.loaderView.startAnimating()
                    self.viewModel.fetchTrendings()
                } else {
                    cell.loaderView.stopAnimating()
                }
                
                return cell
            }
            
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderViewCell.reusableId, for: indexPath) as! HeaderViewCell
            cell.textLabel.text = MainViewSections(rawValue: indexPath.section)?.title.uppercased()
            
            return cell
        }
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {(section, environment) -> NSCollectionLayoutSection in
            switch section {
            case MainViewSections.playingNow.rawValue:
                return self.createPlayingNowSection()
            case MainViewSections.trendings.rawValue:
                return self.createTrandingTodaySection()
            default: fatalError()
            }
        }

        return layout
    }
    
    private func createPlayingNowSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 6, bottom: 0, trailing: 6)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
        section.boundarySupplementaryItems = [getHeaderSection()]
        
        return section
    }
        
    private func createTrandingTodaySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(176))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        section.boundarySupplementaryItems = [getHeaderSection(), getFooterSection()]
        
        return section
    }
    
    private func getHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(28))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        return sectionHeader
    }
    
    private func getFooterSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(48))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        return sectionFooter
    }
}

class LoadMoreViewCell: UICollectionReusableView {
    static let reusableId = "LoadMoreViewCell"
    
    let loaderView = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loaderView)
        
        setupConstrains()
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
