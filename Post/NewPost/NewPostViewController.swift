import UIKit

class NewPostViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let dataSources = NewPostDataSource()
    private var tableViewBottomContraint: NSLayoutConstraint?
    
    // MARK: - UIElements
    
    private let tableView = UITableView()
    private let postBarButton = UIBarButtonItem()
    
    // MARK: - Intialization
    
    init() {
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutAllViews()
        configureAllViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startListenKeyboardFrameWillChangeNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopListenKeyboardFrameWillChangeNotification()
    }
    
    // MARK: - Actions
    
    @objc
    private func postButtonTapped() {
        // needs to configure the actions
    }
    
    // MARK: - KeyboardNotificatoin
    
    private func startListenKeyboardFrameWillChangeNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willKeyboardFrameChange(_:)),
                                               name: UIResponder.keyboardDidChangeFrameNotification, object: .none)
    }
    
    private func stopListenKeyboardFrameWillChangeNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willKeyboardFrameChange(_:)),
                                               name: UIResponder.keyboardDidChangeFrameNotification, object: .none)
    }
    
    @objc private func willKeyboardFrameChange(_ notification: Foundation.Notification) {
        if let userInfo = notification.userInfo as? [String: AnyObject],
            let keyboardEndingFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            let origin = keyboardEndingFrame.origin.y
            let viewMax = tableView.globalFrame?.maxY ?? 0
            let diff = max(0, viewMax - origin)
            tableViewBottomContraint?.constant = -diff
            view.layoutIfNeeded()
            self.dataSources.scrollToCurrentResponder()
        }
    }
    
    private func pushToLocationPicker() {
        let locationPicker = LocationPickerViewController()
        
        // button placed on right bottom corner
        locationPicker.showCurrentLocationButton = true // default: true
        
        // default: navigation bar's `barTintColor` or `.whiteColor()`
        locationPicker.currentLocationButtonBackground = Color.brand
        
        // ignored if initial location is given, shows that location instead
        locationPicker.showCurrentLocationInitially = true // default: true
        
        locationPicker.mapType = .standard // default: .Hybrid
        
        // for searching, see `MKLocalSearchRequest`'s `region` property
        locationPicker.useCurrentLocationAsHint = true // default: false
        
        locationPicker.searchBarPlaceholder = "Search places" // default: "Search or enter an address"
        
        locationPicker.searchHistoryLabel = "Previously searched" // default: "Search History"
        
        // optional region distance to be used for creation region when user selects place from search results
        locationPicker.resultRegionDistance = 500 // default: 600
        
        locationPicker.completion = { [weak self] location in
            if let strongSelf = self {
                strongSelf.dataSources.newPost.location = location
                strongSelf.tableView.reloadData()
            }
        }
        navigationController?.pushViewController(locationPicker, animated: true)
    }
}

// MARK: -

extension NewPostViewController {
    
    // MARK: - Layout
    
    private func layoutAllViews() {
        layoutViewHierarcy()
        layoutTableView()
    }
    
    private func layoutViewHierarcy() {
        view.addSubviewForConstraints(tableView)
    }
    
    private func layoutTableView() {
        tableView.addConstraintsPinningSidesToSuperview([.top, .leading, .trailing],
                                                        useSafeArea: true)
        tableViewBottomContraint = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        tableViewBottomContraint?.isActive = true
    }
    
    // MARK: - Configure
    
    private func configureAllViews() {
        configureView()
        configureNavigationBar()
        configureTableView()
        configureDataSource()
    }
    
    private func configureView() {
        title = "New Post"
    }
    
    private func configureNavigationBar() {
        postBarButton.action = #selector(postButtonTapped)
        postBarButton.title = "Post"
        navigationItem.rightBarButtonItem = postBarButton
        postBarButton.isEnabled = false
    }
    
    private func configureTableView() {
        tableView.dataSource = dataSources
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    private func configureDataSource() {
        dataSources.delegate = self
        dataSources.tableView = tableView
        tableView.reloadData()
    }
}

extension NewPostViewController: NewPostDataSourceDelegate {
    func didSelectedChooseCategories() {
        view.endEditing(true)
        // Configure choose category
    }
    
    func didSelectedChooseLocation() {
        view.endEditing(true)
        pushToLocationPicker()
        // Configure choose location
    }
}
