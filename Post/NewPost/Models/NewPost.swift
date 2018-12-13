import UIKit
import CoreLocation

struct NewPost {
    var title: String?
    var description: String?
    var categories = [Category]()
    var budget: Double?
    var countryCode: IsoCountryInfo? = {
        if let region = Locale.current.regionCode {
            return IsoCountryCodes.find(key: region)
        }
       return .none
    }()
    var rate: Rate?
    var paymentMethod: PaymentMethod?
    var jobTerm: JobTerm?
    var location: Location?
    var startDate: Date?
    var attachements = [Attachment]()
    
    func categoriesString() -> String? {
        if !categories.isEmpty {
            let category = String.plural(count: categories.count, singular: "Category", plural: "Categories")
            return "\(categories.count) \(category) Selected"
        }
        return .none
    }
    
    func budgetString() -> String? {
        if let budget = budget {
            return "\(budget)"
        }
        return .none
    }
    
    func startDateString() -> String? {
        if let date = startDate {
            return "\(date)"
        } else {
            return .none
        }
    }
}

struct Category {
    let name: String
    let image: UIImage
}

struct Attachment {
    let type: AttachementType
    let url: URL
}

//struct Location {
//    let shortTitle: String
//    let fullAddress: String
//    let location: CLLocation
//}

// MARK: - Enums

enum Rate: String, CaseIterable {
    case noPreference = "No Preference"
    case fixed = "Fixed Budget"
    case hourly = "Hourly Rate"
}

enum PaymentMethod: String, CaseIterable {
    case noPrefrence = "No Preference"
    case ePayment = "E-Payment"
    case cash = "Cash"
}

enum JobTerm: String, CaseIterable {
    case noPreference = "No Preference"
    case sameDay = "Same Day Job"
    case multiDays = "Multi Days Job"
    case recurring = "Recurring Job"
}

enum AttachementType {
    case photo
    case video
    case document
}
