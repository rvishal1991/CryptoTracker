//
//  CoinImageService.swift
//  MyCrptoTracker
//
//  Created by apple on 21/05/25.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image:UIImage? = nil
    
    private let coin:Coin
    private let fileMngr = LocalFileManager.instance
    private let folderName = "coin_images"
    private var imageSubscription:AnyCancellable?
    private let imageName:String
    
    init(coin:Coin) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = fileMngr.getImage(imageName: imageName, folderName: folderName){
            image = savedImage
        }else{
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image) else { return  }
        
        imageSubscription =  NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] image in
                guard let self = self, let downloadedImage = image else { return  }
                self.image = image
                self.imageSubscription?.cancel()
                self.fileMngr.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
