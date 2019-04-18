import UIKit

protocol ConfigureModel {
    associatedtype ModelType
    var name: String { get set }
    
    func modelDescription() -> String
}

struct Building {
    var name: String
}
let building = Building(name: "Empire State Building")

struct Tag {
    var name: String
    var building: Building
    var sortIndex: Int?
    func modelDescription() -> String {
        var text = "\(self.name) (\(self.building.name))"
        if let sortIndex = self.sortIndex {
            text.append(" sortIndex: \(sortIndex)")
        }
        return text
        
    }
}
extension Tag: ConfigureModel {
    typealias ModelType = Tag
}

let tag = Tag(name: "My little tag", building: building, sortIndex: 3)

protocol Configure {
    associatedtype ConfigureType
    
    func configure<Model: ConfigureModel>(with value: Model) where Model.ModelType == ConfigureType
}

class ConfigureCell: UITableViewCell {
    
    func configure<Model: ConfigureModel>(with value: Model) {
        let description = value.modelDescription()
        
        print("ConfigureCell description: \(description)")
    }
}

class ObjectDataSource<T: ConfigureModel>: NSObject {
    var values: [T] = []
    
    func cellForRow(at indexPath: IndexPath) {
        let item = self.values[indexPath.row]
        let cell = ConfigureCell()
        
        cell.configure(with: item)
    }
}

let dataSource = ObjectDataSource<Tag>()
dataSource.values = [tag]

let indexPath = IndexPath(row: 0, section: 0)
dataSource.cellForRow(at: indexPath)

