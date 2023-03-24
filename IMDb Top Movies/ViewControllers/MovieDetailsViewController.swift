//
//  MovieDetailsViewController.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 23.03.2023.
//

import Combine
import UIKit

class MovieDetailsViewController: UIViewController {
    
    private struct Constants {
        static let infoText = "Info"
        static let countOfEachCharacterInTitle = "Count of each character in the title"
        static let imageViewWidth: CGFloat = 185
        static let imageViewHeight: CGFloat = 285
        static let scrollViewContainerPadding: CGFloat = 10
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView().withAutoLayout()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "placeholderMovie")
        imageView.addShadow()
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView().withAutoLayout()
        return view
    }()
    
    lazy var scrollStackViewContainer: UIStackView = {
        let view = UIStackView().withAutoLayout()
        view.axis = .vertical
        view.spacing = 5
        return view
    }()
    
    lazy var horizontalStack: UIStackView = {
        let view = UIStackView().withAutoLayout()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 5
        return view
    }()
    
    lazy var infoStackViewContainer: UIStackView = {
        let view = UIStackView().withAutoLayout()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 5
        return view
    }()
    
    lazy var infoTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold)
        return label
    }()
    
    lazy var crewInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var yearInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var imDbRatingInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var imDbRatingCountInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var countOfEachCharacterInTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize, weight: .bold)
        return label
    }()
    
    private lazy var infoDivider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .black
        return divider
    }()
    
    private lazy var contentDivider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .black
        return divider
    }()
    
    let viewModel: MovieDetailsViewModelProtocol
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: MovieDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackgroundColor
        setupBindings()
        addViews()
        setupConstraints()
        setupNavigationBar()
        fetchImage()
        setupData()
    }
    
    private func setupBindings() {
        viewModel.error
            .sink { [weak self] error in
                guard let error = error else { return }
                self?.showToast(with: error)
            }
            .store(in: &cancellable)
    }
    
    private func setupData() {
        infoTitle.text = Constants.infoText
        countOfEachCharacterInTitle.text = Constants.countOfEachCharacterInTitle
        crewInfoLabel.text = viewModel.crewText
        yearInfoLabel.text = viewModel.yearText
        imDbRatingInfoLabel.text = viewModel.imDbRatingText
        imDbRatingCountInfoLabel.text = viewModel.imDbRatingCountText
    }
    
    private func setupNavigationBar() {
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        title = viewModel.movie.title
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
        scrollStackViewContainer.addArrangedSubview(horizontalStack)
        horizontalStack.addArrangedSubview(imageView)
        horizontalStack.addArrangedSubview(infoStackViewContainer)
        
        infoStackViewContainer.addArrangedSubview(infoTitle)
        infoStackViewContainer.addArrangedSubview(infoDivider)
        infoStackViewContainer.addArrangedSubview(crewInfoLabel)
        infoStackViewContainer.addArrangedSubview(yearInfoLabel)
        infoStackViewContainer.addArrangedSubview(imDbRatingInfoLabel)
        infoStackViewContainer.addArrangedSubview(imDbRatingCountInfoLabel)
        infoStackViewContainer.addArrangedSubview(StackViewSpacerView(axis: .vertical, minimumSpace: 0))
        
        scrollStackViewContainer.addArrangedSubview(contentDivider)
        scrollStackViewContainer.addArrangedSubview(countOfEachCharacterInTitle)
        scrollStackViewContainer.addArrangedSubview(getStackViewWithCountingOfEachCharecterInTitle())
    }
    
    private func getStackViewWithCountingOfEachCharecterInTitle() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        
        let totalCountLabel = UILabel()
        totalCountLabel.text = viewModel.totalCountLetterText
        stackView.addArrangedSubview(totalCountLabel)
        
        let stringArray = viewModel.getArrayWithCountingOfEachCharecterInTitle()
        stringArray.forEach { (key, value) in
            let label = UILabel()
            let timeSting = value > 1 ? "times" : "time"
            let attrString = NSMutableAttributedString(string: "Letter \(key) is repeated \(value) \(timeSting).")
            let range = attrString.mutableString.range(of: " \(key) ")
            
            let myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize, weight: .bold) ]
            attrString.addAttributes(myAttribute, range: range)
            label.attributedText = attrString
            stackView.addArrangedSubview(label)
        }
        return stackView
    }
    
    private func setupConstraints() {
        let margins = view.layoutMarginsGuide
        var constraints = [NSLayoutConstraint]()
        constraints += scrollView.constraintsToFillSuperviewHorizontally(leadingMargin: 0, trailingMargin: 0)
        constraints += scrollStackViewContainer.constraintsToFillSuperview(margins: UIEdgeInsets(top: 0, left: Constants.scrollViewContainerPadding, bottom: 0, right: Constants.scrollViewContainerPadding))
        constraints += imageView.constraintsWidthAndHeight(width: Constants.imageViewWidth, height: Constants.imageViewHeight)
        constraints.append(contentsOf: [
            scrollView.topAnchor.constraint(equalTo: margins.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -(Constants.scrollViewContainerPadding * 2)),
            infoDivider.heightAnchor.constraint(equalToConstant: 2),
            contentDivider.heightAnchor.constraint(equalToConstant: 2)
        
        ])
        NSLayoutConstraint.activate(constraints)
    }
    
    private func fetchImage() {
        let id = viewModel.movie.id + "large"
        let queue = DispatchQueue.global(qos: .utility)
        guard let url = viewModel.getURLForLargeImage() else { return }
        if let cached = viewModel.getImageDataFromCache(id: id) {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.imageView.image = UIImage(data: cached)
            }
        } else {
            queue.async { [weak self] in
                guard let data = try? Data(contentsOf: url) else { return }
                DispatchQueue.main.async {
                    guard let strongSelf = self else { return }
                    strongSelf.viewModel.saveImageDataToCache(id: id, url: url.absoluteString, data: data)
                    strongSelf.imageView.image = UIImage(data: data)
                }
            }
        }
    }
}
