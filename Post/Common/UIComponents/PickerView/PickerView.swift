import UIKit

protocol PickerViewDelegate: class {
    func pickerViewDidSelect(at row: Int)
}

class PickerView: UIPickerView {
    
    // MARK: - Properties
    
    weak var pickerViewDelegate: PickerViewDelegate?
    
    var titles: [String] = [] {
        didSet(titleList) {
            refreshPickerView()
        }
    }
    
    // MARK: - Private properties
    
    private let doneToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 40.0))
    private let textField: UITextField
    
    // MARK: - Initialization
    
    init(textField: UITextField) {
        self.textField = textField
        self.textField.tintColor = UIColor.clear
        super.init(frame: CGRect.zero)
        configureAllViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectTitle(row: Int) {
        if row < titles.count {
            selectRow(row, inComponent: 0, animated: true)
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if let text = textField.text,
            let row = titles.firstIndex(of: text) {
            selectTitle(row: row)
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func doneButtonTapped() {
        pickerView(self, didSelectRow: self.selectedRow(inComponent: 0), inComponent: 0)
        textField.resignFirstResponder()
    }
    
    private func refreshPickerView() {
        reloadAllComponents()
    }
    
    // MARK: - Configure
    
    private func configureAllViews() {
        configureView()
        configureDoneToolBar()
        configureTextField()
    }
    
    private func configureView() {
        delegate = self
        dataSource = self
        backgroundColor = Color.tintColor
    }
    
    private func configureDoneToolBar() {
        doneToolBar.tintColor = Color.tintColor
        doneToolBar.barTintColor = Color.lightGray
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                         target: self,
                                         action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace,
                                                 target: self,
                                                 action: .none)
        doneToolBar.setItems([flexibleSpace, doneButton], animated: false)
    }
    
    private func configureTextField() {
        textField.inputView = self
        textField.inputAccessoryView = doneToolBar
    }
}

// MARK: - UIPickerViewDelegate

extension PickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = titles[row]
        let newPosition = textField.beginningOfDocument
        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        pickerViewDelegate?.pickerViewDidSelect(at: row)
    }
}

// MARK: - UIPickerViewDatasource

extension PickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titles.count
    }
}
