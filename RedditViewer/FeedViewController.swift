//
//  ViewController.swift
//  RedditViewer
//
//  Created by Nathan Pabrai on 11/27/22.
//

import Combine
import UIKit

class FeedViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .plain)
    let refreshControl = UIRefreshControl()
    static let cellReuseId = "PostCellReuseId"
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // TODO: store the posts per subreddit so we dont clear all posts when switching subreddits
    let viewModel = PostsViewModel()
    var subreddit = Subreddit.memes {
        didSet {
            handleSubredditChanged()
        }
    }
    let fetcher = NetworkFetcher()
    var cancellable: AnyCancellable?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    lazy var subredditButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = subreddit.displayString
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitle(subreddit.displayString, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
        subscribeToViewModel()
        
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        view.addSubviewWithEqualEdgeConstraints(tableView)
        view.addSubviewWithEqualEdgeConstraints(activityIndicator)
        view.addSubviewIgnoringAutoresizingMask(subredditButton)
        let memesAction = UIAction(title: Subreddit.memes.displayString, handler: { _ in
            self.showMemes()
        })
        
        let landscapesAction = UIAction(title: Subreddit.landscapes.displayString, handler: { _ in
            self.showLandscapes()
        })
        
        let menu = UIMenu(title: "Subreddits", children: [memesAction, landscapesAction])
        subredditButton.menu = menu
        subredditButton.showsMenuAsPrimaryAction = true
                                                         
        NSLayoutConstraint.activate([
            subredditButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -11),
            subredditButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        activityIndicator.startAnimating()
        fetch()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .black
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: Self.cellReuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
        refreshControl.tintColor = .white
    }
    
    private func subscribeToViewModel() {
        cancellable = viewModel.$posts.receive(on: DispatchQueue.main).sink { _ in
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
        }
    }
    
    
    @objc
    private func fetch() {
        activityIndicator.startAnimating()
        fetcher.getPostsFor(subreddit: subreddit, updatingViewModel: viewModel)
    }
    
    @objc
    private func showMemes() {
        subreddit = .memes
    }
    
    @objc
    private func showLandscapes() {
        subreddit = .landscapes
    }
    
    private func handleSubredditChanged() {
        subredditButton.setTitle(subreddit.displayString, for: .normal)
        viewModel.posts = []
        fetch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellable?.cancel()
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseId, for: indexPath) as? PostTableViewCell else {
            print("Unexpected cell type dequeued")
            return UITableViewCell()
        }
        
        let post = viewModel.posts[indexPath.row]
        cell.configureWith(post)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.posts.count
    }
    
}

extension FeedViewController: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !tableView.isDragging else { return }
        snapToCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard !tableView.isDragging else { return }
        snapToCell()
    }
}

extension FeedViewController {
    /// Repositions the cell that occupies the center of the table view with the cell's top at the top of the table view
    func snapToCell() {
        if let centerIndexPath = tableView.indexPathForRow(at: CGPointMake( CGRectGetMidX(tableView.bounds), CGRectGetMidY(tableView.bounds))) {
            self.tableView.scrollToRow(at: centerIndexPath, at: .top, animated: true)
        }
    }
}
