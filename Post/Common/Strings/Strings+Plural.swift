import Foundation

extension String {
    static func plural(count: Int, singular: String, plural: String) -> String {
        return count > 1 ? plural : singular
    }
}
