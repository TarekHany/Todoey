//
//  Category.swift
//  Todoey
//
//  Created by Tarek Hany on 9/30/20.
//  Copyright © 2020 Tarek Hany. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
     @objc dynamic var name: String = ""
     @objc dynamic var color: String = ""
     let items = List<Item>()
}
