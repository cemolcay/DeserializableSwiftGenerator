import UIKit
class AwsomeClass: AwsomeSuperClass {


	var AwsomeProperty: String?
	

	required init (data: [String: AnyObject]) {
		super.init (data: data)
		AwsomeProperty <<< data["awsome_property"]
		
	}
}