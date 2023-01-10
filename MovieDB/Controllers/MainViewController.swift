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
    
    var viewModel = MainViewModel(service: Service())
    
    var collectionView: UICollectionView!
    var snapshot: NSDiffableDataSourceSnapshot<MainViewSections, AnyHashable> = NSDiffableDataSourceSnapshot()
    var dataSource: UICollectionViewDiffableDataSource<MainViewSections, AnyHashable>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MovieDB"
        view.backgroundColor = .secondarySystemBackground
        
        setupView()
        setupBind()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchData()
    }
    
    private func setupView() {
        view.addSubview(loaderView)
        
        setupCollectionView()
        view.addSubview(collectionView)
    }
    
    private func setupBind() {
        viewModel.nowPlaying
            .subscribe(onNext: { [weak self] movies in
                self?.snapshot.appendSections([.playingNow])
                self?.snapshot.appendItems(movies, toSection: .playingNow)
                self?.dataSource.apply(self!.snapshot)
                print(movies.count)
            })
            .disposed(by: disposeBag)
        
        viewModel.trendings
            .subscribe(onNext: { [weak self] movies in
                self?.snapshot.appendSections([.trendings])
                self?.snapshot.appendItems(movies, toSection: .trendings)
                self?.dataSource.apply(self!.snapshot)
                print(movies.count)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .bind(to: loaderView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] path in
                let model = self?.dataSource.itemIdentifier(for: path)
                print(model)
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
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCell.reusableId)
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
                cell.configure(with: object as! MovieModel)
                return cell
            default: return nil
            }
        })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCell.reusableId, for: indexPath) as! HeaderCell
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
        section.boundarySupplementaryItems = [headerSection()]
        
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
        section.boundarySupplementaryItems = [headerSection()]
        
        return section
    }
    
    private func headerSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(28))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return sectionHeader
    }
}
