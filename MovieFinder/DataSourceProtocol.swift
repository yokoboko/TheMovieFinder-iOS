//
//  DataSourceProtocol.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 6.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

protocol DataSourceProtocol: class {
    var isLoadingData: Bool { get }
}
