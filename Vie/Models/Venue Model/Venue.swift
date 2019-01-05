
import Foundation
import SwiftyJSON
import SwifterSwift

public class Venue {
    public var index : Int?
    public var venueId : String?
    public var name : String?
    public var location : Location?
    
    init(json: JSON) throws {
        venueId = json["id"].stringValue
        name = json["name"].stringValue
        location =  try? Location(json: json["location"])
        index = 0
    }
}
