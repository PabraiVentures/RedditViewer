//
//  PostTableViewCell.swift
//  RedditViewer
//
//  Created by Nathan Pabrai on 11/27/22.
//

import Kingfisher
import UIKit

// TODO: Extract sizes/fonts into a seperate Style file
// TODO: Add the 'Inter' font to the project and update labels to use it

class PostTableViewCell: UITableViewCell {
    lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    let titleTextColor = UIColor.white.withAlphaComponent(0.9)
    lazy var upvoteCountLabel = numberLabel(text: "0")
    lazy var commentCountLabel = numberLabel(text: "0")
    lazy var iconStack = setupIconStack()
    lazy var labelStack = setupLabelStack()
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = titleTextColor
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        activityIndicator.tintColor = .white
        backgroundColor = .black
        contentView.backgroundColor = .black
        contentView.addSubviewWithEqualEdgeConstraints(postImageView)
        contentView.addSubviewIgnoringAutoresizingMask(iconStack)
        contentView.addSubviewIgnoringAutoresizingMask(labelStack)
        contentView.addSubviewWithEqualEdgeConstraints(activityIndicator)
        NSLayoutConstraint.activate([
            iconStack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -35),
            iconStack.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -17.5),
            labelStack.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            labelStack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -35),
            labelStack.trailingAnchor.constraint(equalTo: iconStack.safeAreaLayoutGuide.leadingAnchor, constant: -17.5),

        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(_ post: Post) {
        contentView.backgroundColor = .black
        commentCountLabel.text = "\(post.numComments)"
        upvoteCountLabel.text = "\(post.ups)"
        authorLabel.text = "u/\(post.author)"
        titleLabel.text = post.title
        activityIndicator.startAnimating()
        if let postURL = URL(string: post.url) {
            postImageView.kf.setImage(with: postURL) { _ in
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        postImageView.kf.cancelDownloadTask()
    }
    
    private func numberLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.text = text
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    private func setupIconStack() -> UIView {
        let stack = UIStackView()
        stack.alpha = 0.9
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 5
        
        let upvoteIcon = upvoteIcon()
        stack.addArrangedSubview(upvoteIcon)
        stack.addArrangedSubview(upvoteCountLabel)
        stack.setCustomSpacing(22.5, after: upvoteCountLabel)
        
        let commentIcon = commentIcon()
        stack.addArrangedSubview(commentIcon)
        stack.addArrangedSubview(commentCountLabel)
        
        return stack
    }
    
    private func commentIcon() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "comment"))
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 35),
            imageView.heightAnchor.constraint(equalToConstant: 33.23)
        ])
        return imageView
    }
    
    private func upvoteIcon() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "upvote"))
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 28),
            imageView.heightAnchor.constraint(equalToConstant: 30.23)
        ])
        return imageView
    }
    
    private func setupLabelStack() -> UIView {
        let stack = UIStackView(arrangedSubviews: [authorLabel, titleLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 8
        
        return stack
    }
}
