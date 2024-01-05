//
//  ImageLoaderProtocol.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 05.01.2024.
//

import UIKit
import Foundation

protocol ImageLoadable {
    func loadImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}
