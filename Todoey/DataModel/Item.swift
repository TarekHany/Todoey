//
//  Item.swift
//  Todoey
//
//  Created by Tarek Hany on 9/30/20.
//  Copyright © 2020 Tarek Hany. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
