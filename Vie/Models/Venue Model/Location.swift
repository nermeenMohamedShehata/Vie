
import Foundation
import SwiftyJSON
import SwifterSwift

public class Location {
	public var address : String?
	public var lat : Double?
	public var lng : Double?
    init(json: JSON) throws {
        address = json["address"].stringValue
        lat = json["lat"].doubleValue
        lng = json["lng"].doubleValue
    }
}
