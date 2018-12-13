import UIKit

protocol NewPostDataSourceDelegate: class {
    func didSelectedChooseCategories()
    func didSelectedChooseLocation()
}

enum Row: Int, CaseIterable {
    case title = 0
    case description
    case categories
    case budgetCountry
    case ratePayment
    case location
    case dateTerms
//    case attachments
}
enum Field: Int, CaseIterable {
    case title = 0
    case description
    case categories
    case budget
    case country
    case rate
    case payment
    case location
    case date
    case terms
//    case attachments
    
    func row() -> Row {
        var row: Row
        switch self {
        case .title:
            row = .title
        case .description:
            row = .description
        case .categories:
            row = .categories
        case .budget:
            row = .budgetCountry
        case .country:
            row = .budgetCountry
        case .rate:
            row = .ratePayment
        case .payment:
            row = .ratePayment
        case .location:
            row = .location
        case .date:
            row = .dateTerms
        case .terms:
            row = .dateTerms
//        case .attachments:
//            row = .attachments
        }
        return row
    }
}

class NewPostDataSource: NSObject {
    
    // MARK: - Public properties
    
    var newPost = NewPost()
    weak var delegate: NewPostDataSourceDelegate?
    weak var tableView: UITableView?
    
    private weak var currentResponder: UIView?
    
    func scrollToCurrentResponder() {
        if let currentResponder = currentResponder,
            let row = Field(rawValue: currentResponder.tag)?.row(),
            let tableView = tableView,
            let textFieldFrame = currentResponder.frameTo(view: tableView) {
            print("Text field framet: \(textFieldFrame)")
            let height = tableView.frame.size.height
            print("Table view Height: \(height)")
            let ydiff = max(textFieldFrame.maxY + 20 - height, 0)
            print("Y difference: \(ydiff)")
//            tableView.setContentOffset(CGPoint(x: 0, y: ydiff), animated: true)
            
            let indexPath = IndexPath(row: min(row.rawValue, Row.allCases.count - 1), section: 0)
            tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.none, animated: false)
        }
    }
    
    private func saveChanges(_ text: String, field: Field) {
        switch field {
        case .title:
            newPost.title = text
        case .description:
            newPost.description = text
        case .budget:
            newPost.budget = Double(text)
        case .rate:
            newPost.rate = Rate(rawValue: text)
        case .payment:
            newPost.paymentMethod = PaymentMethod(rawValue: text)
        case .date:
            newPost.startDate = nil
        case .terms:
            newPost.jobTerm = JobTerm(rawValue: text)
        default:
            print("Not supported")
        }
        print("New post: \(newPost)")
    }
    
    private func setRightIcon(_ textField: UITextField, image: UIImage?) {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        textField.rightView = imageView
        textField.rightViewMode = .always
    }
}
extension NewPostDataSource {
    
    // MARK: - Configure cells
    
    private func configureTitleTextField(_ textField: LabeledTextField) {
        textField.text = newPost.title
        textField.labelText = "Post Title"
        textField.placeholderText = "Enter Post Title"
        textField.maximumLength = 50
        textField.textField.tag = Field.title.rawValue
        textField.textFieldDelegate = self
    }
    
    private func configureDescribeTextField(_ textField: LabeledTextField) {
        textField.text = newPost.description
        textField.labelText = "Post Description"
        textField.placeholderText = "Describe Your Post"
        textField.maximumLength = 350
        textField.textField.tag = Field.description.rawValue
        textField.textFieldDelegate = self
    }
    
    private func configureCategoriesTextField(_ textField: LabeledTextField) {
        textField.text = newPost.categoriesString()
        textField.labelText = "Post Categories"
        textField.placeholderText = "Select Post Categories"
        textField.textField.tag = Field.categories.rawValue
        textField.textFieldDelegate = self
        setRightIcon(textField.textField, image: #imageLiteral(resourceName: "category.png"))
    }
    
    private func configureBudgetTextField(_ textField: LabeledTextField) {
        textField.text = newPost.budgetString()
        textField.labelText = "Budget"
        textField.placeholderText = "Budget"
        textField.textField.tag = Field.budget.rawValue
        textField.textField.keyboardType = .decimalPad
        textField.textFieldDelegate = self
    }
    
    private func configureCountryTextTableViewCell(_ textField: LabeledTextField) {
        if let country = newPost.countryCode {
            textField.text = country.flag + " " + country.name
        }
        textField.placeholderText = "Choose Country"
        textField.textField.tag = Field.country.rawValue
        textField.textFieldDelegate = self
        
        textField.configurePickerView(pickerTitles: IsoCountries.allCountries.map({ (country) in
            return country.flag + " " + country.name
        }))
    }
    
    private func configureRateTextField(_ textField: LabeledTextField) {
        textField.text = newPost.rate?.rawValue
        textField.labelText = "Rate"
        textField.placeholderText = "Rate"
        textField.textField.tag = Field.rate.rawValue
        textField.textFieldDelegate = self
        textField.configurePickerView(pickerTitles: Rate.allCases.map({ (rate) in
            return rate.rawValue
        }))
    }
    
    private func configurePaymentTextTableViewCell(_ textField: LabeledTextField) {
        textField.text = newPost.paymentMethod?.rawValue
        textField.labelText = "Payment Method"
        textField.placeholderText = "Payment Method"
        textField.textField.tag = Field.payment.rawValue
        textField.textFieldDelegate = self
        textField.configurePickerView(pickerTitles: PaymentMethod.allCases.map({ (rate) in
            return rate.rawValue
        }))
    }
    
    private func configureLocationTextField(_ textField: LabeledTextField) {
        textField.text = newPost.location?.address
        textField.labelText = "Location"
        textField.placeholderText = "Location"
        textField.textField.tag = Field.location.rawValue
        textField.textFieldDelegate = self
        setRightIcon(textField.textField, image: #imageLiteral(resourceName: "location.png"))
    }
    
    private func configureSelectDateTextField(_ textField: LabeledTextField) {
        textField.text = newPost.startDateString()
        textField.labelText = "Start Date"
        textField.placeholderText = "Start Date"
        textField.textField.tag = Field.date.rawValue
        textField.textFieldDelegate = self
    }
    
    private func configureTermTextTableViewCell(_ textField: LabeledTextField) {
        textField.text = newPost.jobTerm?.rawValue
        textField.labelText = "Job Term"
        textField.placeholderText = "Job Term"
        textField.textField.tag = Field.terms.rawValue
        textField.textFieldDelegate = self
        textField.configurePickerView(pickerTitles: JobTerm.allCases.map({ (rate) in
            return rate.rawValue
        }))
    }
}

extension NewPostDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let row = Row(rawValue: indexPath.row) {
            switch row {
            case .title:
                let cell = TextTableViewCell()
                configureTitleTextField(cell.textField)
                return cell
            case .description:
                let cell = TextTableViewCell()
                configureDescribeTextField(cell.textField)
                return cell
            case .categories:
                let cell = TextTableViewCell()
                configureCategoriesTextField(cell.textField)
                return cell
            case .budgetCountry:
                let cell = DoubleTextTableViewCell()
                configureBudgetTextField(cell.leftTextField)
                configureCountryTextTableViewCell(cell.rightTextField)
                return cell
            case .ratePayment:
                let cell = DoubleTextTableViewCell()
                configureRateTextField(cell.leftTextField)
                configurePaymentTextTableViewCell(cell.rightTextField)
                return cell
            case .location:
                let cell = TextTableViewCell()
                configureLocationTextField(cell.textField)
                return cell
            case .dateTerms:
                let cell = DoubleTextTableViewCell()
                configureSelectDateTextField(cell.leftTextField)
                configureTermTextTableViewCell(cell.rightTextField)
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension NewPostDataSource: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let field = Field(rawValue: textField.tag) {
            switch field {
            case .categories:
                delegate?.didSelectedChooseCategories()
            case .location:
                delegate?.didSelectedChooseLocation()
            default:
                currentResponder = textField
                return true
            }
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text,
            let field = Field(rawValue: textField.tag) {
            saveChanges(text, field: field)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
