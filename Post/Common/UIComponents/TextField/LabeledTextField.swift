import UIKit

enum LabledTextFieldState {
    case normal
    case active
    case error
}

class LabeledTextField: UIView {
    
    // MARK: - UI Elements
    
    private let stackView = UIStackView()
    private let label = UILabel()
    let textField = TextField()
    private let seperatorView = UIView()
    private let helperLabel = UILabel()
    
    private lazy var pickerInputView = {
        return PickerView(textField: self.textField)
    }()
    
    // MARK: - Public properties
    
    weak var textFieldDelegate: UITextFieldDelegate?

    var state: LabledTextFieldState = .normal {
        didSet {
            configureAllViews()
        }
    }
    
    var text: String? {
        set {
            textField.text = newValue
        }
        get {
            return textField.text
        }
    }
    
    var labelText: String = " " {
        didSet {
            configureLabel()
        }
    }
    
    var helperText: String = " " {
        didSet {
            configureHelperLabel()
        }
    }
    
    var placeholderText: String? {
        didSet {
            configureTextField()
        }
    }
    
    var maximumLength: Int? {
        didSet {
            configureHelperLabel()
        }
    }
    
    // MARK: - Initalization
    
    convenience init(keyboardType: UIKeyboardType = .default) {
        self.init(frame: .zero)
        textField.keyboardType = keyboardType
    }
    
    override init(frame: CGRect) {
        self.state = .normal
        
        super.init(frame: frame)
        
        layoutAllViews()
        configureAllViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    func configurePickerView(pickerTitles: [String]) {
        pickerInputView.titles = pickerTitles
        pickerInputView.pickerViewDelegate = self
        
    }
    
    // MARK: - Private methods
    
    @objc
    private func clearText() {
        
        textField.text = ""
        textField.sendActions(for: .editingChanged)
    }
    
    private func getHelperText(_ newTextFieldText: String?) -> String? {
        if let maxLength = maximumLength {
            let left = maxLength - (newTextFieldText?.count  ?? 0)
            let character = String.plural(count: left, singular: "Character", plural: "Characters")
            return "\(left) \(character) left"
        } else {
            return helperText
        }
    }
    
    @objc private func doneButtonTapped() {
        textField.resignFirstResponder()
    }
}

extension LabeledTextField {
    
    // MARK: - Layout
    
    private func layoutAllViews() {
        layoutViewHierarchy()
        layoutStackView()
        layoutSeperatorView()
    }
    
    private func layoutViewHierarchy() {
        
        addSubviewForConstraints(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(seperatorView)
        stackView.addArrangedSubview(helperLabel)
    }
    
    private func layoutStackView() {
        stackView.addConstraintsPinningSidesToSuperview([.trailing, .leading], constant: 15.0)
        stackView.addConstraintsPinningSidesToSuperview([.top], constant: 10.0)
        stackView.addConstraintsPinningSidesToSuperview([.bottom], constant: 0.0)
        stackView.spacing = 0.0
        stackView.setCustomSpacing(10.0, after: label)
        stackView.setCustomSpacing(5.0, after: textField)
        stackView.setCustomSpacing(5.0, after: seperatorView)
        stackView.setCustomSpacing(0.0, after: helperLabel)
        stackView.axis = .vertical
    }
    
    private func layoutSeperatorView() {
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    // MARK: - Configuration
    
    private func configureAllViews() {
        configureLabel()
        configureTextField()
        configureSeperatorView()
        configureHelperLabel()
    }

    private func configureLabel() {
        label.text = labelText
        label.numberOfLines = 0
        label.textColor = Color.lightGray
        label.font = Font.smallBody
        let text = (textField.text ?? "").isEmpty ? " " : labelText
        label.text = state == .active ? labelText : text
    }
    
    private func configureTextField() {
        textField.layer.borderWidth = 0
        textField.font = Font.body
        textField.delegate = self
        textField.textColor = Color.brand
        configurePlaceHolder()
    }
    
    private func configurePlaceHolder() {
        let color = state == .active ? UIColor.clear : Color.lightGray
        if let placeholderText = placeholderText {
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
    
    private func configureHelperLabel() {
        helperLabel.font = Font.smallBody
        helperLabel.numberOfLines = 0
        helperLabel.textColor = Color.lightGray
        helperLabel.textAlignment = .right
        helperLabel.text = state == .active ? getHelperText(textField.text) : " "
    }
    
    private func configureHelpLabel(_ textFieldText: String?) {
        helperLabel.text = state == .active ? getHelperText(textFieldText) : " "
    }
    
    private func configureSeperatorView() {
        seperatorView.backgroundColor = state == .active ? Color.brand : Color.lightGray
    }
}

extension LabeledTextField: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return textFieldDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        state = .active
        configureAllViews()
        
        if let textFieldDelegate = textFieldDelegate {
            textFieldDelegate.textFieldDidBeginEditing?(textField)
        }
    }
    
    func textFieldDidEndEditing(_ otherTextField: UITextField) {
        state = .normal
        configureAllViews()
        
        if let textFieldDelegate = textFieldDelegate {
            textFieldDelegate.textFieldDidEndEditing?(otherTextField)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textFieldDelegate?.textFieldShouldReturn?(textField) ?? true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let maxLength = maximumLength {
            let newString = (textField.text as NSString?)?.replacingCharacters(in: range,
                                                                               with: string)
            if let newString = newString, newString.count > maxLength {
                return false
            }
            configureHelpLabel(newString)
        }
        
        return textFieldDelegate?.textField?(textField,
                                             shouldChangeCharactersIn: range,
                                             replacementString: string) ?? true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return textFieldDelegate?.textFieldShouldClear?(textField) ?? true
    }
}

extension LabeledTextField: PickerViewDelegate {
    func pickerViewDidSelect(at row: Int) {
        configureAllViews()
        debugPrint("Picker selected at row: \(row)")
    }
}
